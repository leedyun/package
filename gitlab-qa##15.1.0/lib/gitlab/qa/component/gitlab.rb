# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize

require 'securerandom'
require 'net/http'
require 'uri'
require 'forwardable'
require 'openssl'
require 'tempfile'
require 'json'

module Gitlab
  module QA
    module Component
      class Gitlab < Base
        extend Forwardable
        using Rainbow

        attr_reader :release,
          :omnibus_configuration,
          :omnibus_gitlab_rails_env,
          :authority_volume,
          :ssl_volume

        attr_accessor :tls,
          :skip_availability_check,
          :runner_network,
          :seed_admin_token,
          :seed_db,
          :skip_server_hooks,
          :gitaly_tls

        attr_writer :name, :relative_path

        def_delegators :release, :tag, :image, :edition

        DATA_SEED_PATH = File.expand_path('../../../../support/data', __dir__)

        TRUSTED_PATH = '/etc/gitlab/trusted-certs'
        SSL_PATH = '/etc/gitlab/ssl'
        DATA_PATH = '/tmp/data-seeds'

        def initialize
          super

          @skip_availability_check = false
          @omnibus_gitlab_rails_env = {}
          @omnibus_configuration = Runtime::OmnibusConfiguration.new(Runtime::Scenario.omnibus_configuration)
          @cert_volumes = { "authority" => TRUSTED_PATH, "gitlab-ssl" => SSL_PATH }
          @seed_admin_token = Runtime::Scenario.seed_admin_token
          @seed_db = Runtime::Scenario.seed_db
          @skip_server_hooks = Runtime::Scenario.skip_server_hooks

          self.release = 'CE'
        end

        def set_formless_login_token
          return if Runtime::Env.gitlab_qa_formless_login_token.to_s.strip.empty?

          @omnibus_gitlab_rails_env['GITLAB_QA_FORMLESS_LOGIN_TOKEN'] = Runtime::Env.gitlab_qa_formless_login_token
        end

        def set_license_mode
          return unless Runtime::Env.gitlab_license_mode == 'test'

          @omnibus_gitlab_rails_env['GITLAB_LICENSE_MODE'] = 'test'
          @omnibus_gitlab_rails_env['CUSTOMER_PORTAL_URL'] = Runtime::Env.customer_portal_url
        end

        def set_cloud_connector_base_url
          return if Runtime::Env.cloud_connector_base_url.blank?

          @omnibus_gitlab_rails_env['CLOUD_CONNECTOR_BASE_URL'] = Runtime::Env.cloud_connector_base_url
        end

        # Sets GITLAB_QA_USER_AGENT as a Rail environment variable so that it can be used by GitLab to bypass features
        # that can't be automated.
        def set_qa_user_agent
          return if Runtime::Env.gitlab_qa_user_agent.to_s.strip.empty?

          @omnibus_gitlab_rails_env['GITLAB_QA_USER_AGENT'] = Runtime::Env.gitlab_qa_user_agent
          secrets << Runtime::Env.gitlab_qa_user_agent
        end

        def elastic_url=(url)
          @environment['ELASTIC_URL'] = url
        end

        def set_ee_activation_code
          raise 'QA_EE_ACTIVATION_CODE is required!' if Runtime::Env.ee_activation_code.to_s.strip.empty?

          @omnibus_gitlab_rails_env['QA_EE_ACTIVATION_CODE'] = Runtime::Env.ee_activation_code
          secrets << Runtime::Env.ee_activation_code
        end

        def release=(release)
          @release = QA::Release.new(release)
        end

        def name
          @name ||= "gitlab-#{edition}-#{SecureRandom.hex(4)}"
        end

        def address
          "#{scheme}://#{hostname}#{relative_path}"
        end

        def scheme
          tls ? 'https' : 'http'
        end

        def gitlab_port
          tls ? ["443:443"] : ["80"]
        end

        def relative_path
          @relative_path ||= ''
        end

        def set_accept_insecure_certs
          Runtime::Env.accept_insecure_certs = 'true'
        end

        def prepare
          prepare_gitlab_omnibus_config
          copy_certificates

          super
        end

        def pull
          docker.login(**release.login_params) if release.login_params

          super
        end

        def exist?(image, tag)
          docker.manifest_exists?("#{image}:#{tag}")
        end

        def prepare_gitlab_omnibus_config
          @omnibus_configuration.expand_config_template(self)
          set_formless_login_token
          set_license_mode
          set_qa_user_agent
          set_cloud_connector_base_url
          env = @omnibus_gitlab_rails_env.merge(
            {
              'GITLAB_ALLOW_SEPARATE_CI_DATABASE' => Runtime::Env.allow_separate_ci_database.to_s,
              'COVERBAND_ENABLED' => Runtime::Env.coverband_enabled?.to_s
            }
          )

          @omnibus_configuration << "gitlab_rails['env'] = #{env}"
        end

        def start # rubocop:disable Metrics/AbcSize
          ensure_configured!

          docker.run(image: image, tag: tag) do |command|
            command << "-d"
            command << "--shm-size 256m"
            command << "--name #{name}"
            command << "--net #{network}"
            command << "--hostname #{hostname}"

            [*@ports, *gitlab_port].each do |mapping|
              command.port(mapping)
            end

            @volumes.to_h.merge(cert_volumes).each do |to, from|
              command.volume(to, from, 'Z')
            end

            command.volume(File.join(Runtime::Env.host_artifacts_dir, name, 'logs'), '/var/log/gitlab', 'Z')

            @environment.to_h.each do |key, value|
              command.env(key, value)
            end

            @network_aliases.to_a.each do |network_alias|
              command << "--network-alias #{network_alias}"
            end

            @additional_hosts.each do |host|
              command << "--add-host=#{host}"
            end
          end

          return unless runner_network

          Docker::Command.execute(
            "network connect --alias #{name}.#{network} --alias #{name}.#{runner_network} #{runner_network} #{name}"
          )
        end

        # Path of the log file to write to
        # @note
        #   if an error occurs during #reconfigure,
        #   "retry-{n}" is prefixed to the file name where {n} is retry number
        # @return [String] the path to the log file
        def log_file
          retries = 0
          log_file = "#{Runtime::Env.host_artifacts_dir}/#{name}-reconfigure.log"
          while File.exist?(log_file)
            break unless File.exist?(log_file)

            retries += 1
            log_file = "#{Runtime::Env.host_artifacts_dir}/#{name}-retry-#{retries}-reconfigure.log"
          end

          log_file
        end

        def get_reconfigure_log_file_from_artefact
          all_reconfigure_log_file = Dir["#{Runtime::Env.host_artifacts_dir}/*reconfigure.log"].sort_by { |f| File.mtime(f) }
          all_reconfigure_log_file.last
        end

        private :log_file

        def reconfigure
          setup_omnibus
          log_file_path = log_file
          config_file = File.open(log_file_path, "w")
          @docker.attach(name) do |line, _wait|
            config_file.write(line)

            if line.include?('There was an error running gitlab-ctl reconfigure')
              Runtime::Logger.error(
                "Failure while running gitlab-ctl reconfigure command. Please check the #{log_file_path} in the artefact for more info"
              )
            end

            # TODO, workaround which allows to detach from the container
            break if line.include?('gitlab Reconfigured!')
          end
        end

        def wait_until_ready
          return if skip_availability_check

          availability = Availability.new(
            name,
            relative_path: relative_path,
            scheme: scheme,
            protocol_port: gitlab_port.first.to_i
          )

          Runtime::Logger.info("Waiting for GitLab to become healthy ...")

          if availability.check(Runtime::Env.gitlab_availability_timeout)
            Runtime::Logger.info("-> GitLab is available at `#{availability.uri}`!".bright)
          else
            abort '-> GitLab unavailable!'.red
          end
        end

        def process_exec_commands
          Support::ConfigScripts.add_git_server_hooks(docker, name) unless skip_server_hooks

          @docker.copy(name, DATA_SEED_PATH, DATA_PATH) if seed_admin_token || seed_db
          exec_commands << seed_admin_token_command if seed_admin_token
          exec_commands << seed_test_data_command if seed_db
          exec_commands << Runtime::Scenario.omnibus_exec_commands

          commands = exec_commands.flatten.uniq
          return if commands.empty?

          Runtime::Logger.info("Running exec_commands...")
          commands.each { |command| @docker.exec(name, command, mask_secrets: secrets) }
        end

        def rails_version
          manifest = JSON.parse(read_package_manifest)
          {
            sha: manifest['software']['gitlab-rails']['locked_version'],
            source: manifest['software']['gitlab-rails']['locked_source']['git']
          }
        end

        def package_version
          manifest = JSON.parse(read_package_manifest)
          manifest['software']['package-scripts']['locked_version']
        end

        def create_key_file(env_key)
          directory = ENV['CI_PROJECT_DIR'] || Dir.tmpdir
          unique_filename = "#{env_key.downcase}_#{Time.now.to_i}_#{rand(100)}"
          key_file_path = File.join(directory, unique_filename)

          File.open(key_file_path, 'w') do |file|
            file.write(ENV.fetch(env_key))
            file.fsync
          end

          File.chmod(0o744, key_file_path)
          @volumes[key_file_path] = key_file_path

          key_file_path
        end

        def delete_key_file(path)
          FileUtils.rm_f(path)
        end

        def teardown!
          log_pg_stats

          super
        end

        private

        attr_reader :cert_volumes

        def read_package_manifest
          @docker.read_file(@release.image, @release.tag, '/opt/gitlab/version-manifest.json')
        end

        # Create cert files in separate volumes
        #
        # tls_certificates folder can't be mounted directly when remote docker context is used
        # due to not having access to local dir
        #
        # @return [void]
        def copy_certificates
          Alpine.perform do |alpine|
            alpine.volumes = cert_volumes

            alpine.start_instance
            docker.copy(alpine.name, "#{CERTIFICATES_PATH}/authority/.", TRUSTED_PATH)
            docker.copy(alpine.name, "#{CERTIFICATES_PATH}/#{gitaly_tls ? 'gitaly' : 'gitlab'}/.", SSL_PATH)
          ensure
            alpine.teardown! # always remove container, even when global `--no-tests` flag was provided
          end
        end

        def ensure_configured!
          raise 'Please configure an instance first!' unless [name, release, network].all?
        end

        def setup_omnibus
          @docker.write_files(name, mask_secrets: secrets) do |f|
            f.write('/etc/gitlab/gitlab.rb', @omnibus_configuration.to_s)
          end
        end

        def seed_test_data_command
          cmd = []

          Runtime::Scenario.seed_db.each do |file_patterns|
            Dir["#{DATA_SEED_PATH}/#{file_patterns}"].map { |f| File.basename f }.each do |file|
              cmd << "gitlab-rails runner #{DATA_PATH}/#{file}"
            end
          end

          cmd.uniq
        end

        def seed_admin_token_command
          ["gitlab-rails runner #{DATA_PATH}/admin_access_token_seed.rb"]
        end

        def log_pg_stats
          Runtime::Logger.debug('Fetching pg statistics')
          File.open("#{Runtime::Env.host_artifacts_dir}/pg_stats.log", 'a') do |file|
            file << "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} -- #{name} -- Postgres statistics after test run:\n"
            file << "Live and dead row counts:\n"
            file << @docker.exec(name, %(gitlab-psql -c 'select n_live_tup, n_dead_tup, relname from pg_stat_all_tables order by n_live_tup DESC, n_dead_tup DESC;'))
            file << "Cumulative user table statistics:\n"
            file << @docker.exec(name, %(gitlab-psql -c 'select * from pg_stat_user_tables;'))
          end
        rescue StandardError => e
          Runtime::Logger.error("Error getting pg statistics: #{e}")
        end

        class Availability
          def initialize(name, relative_path: '', scheme: 'http', protocol_port: 80)
            @docker = Docker::Engine.new

            @name = name
            @scheme = scheme
            @relative_path = relative_path
            @protocol_port = protocol_port
          end

          def check(retries)
            retries.times do
              return true if service_available?

              sleep 1
            end

            false
          end

          def uri
            @uri ||= begin
              port = docker.port(name, protocol_port).split(':').last

              URI.join("#{scheme}://#{docker.hostname}:#{port}", relative_path)
            end
          end

          private

          attr_reader :docker, :name, :relative_path, :scheme, :protocol_port

          def service_available?
            output = docker.inspect(name) { |command| command << "--format='{{json .State.Health.Status}}'" }

            output == '"healthy"'
          rescue Support::ShellCommand::StatusError
            false
          end
        end
      end
    end
  end
end
# rubocop:enable Metrics/AbcSize
