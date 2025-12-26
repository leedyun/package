# frozen_string_literal: true

module Gitlab
  module QA
    module Docker
      class Engine
        DOCKER_HOST = ENV['DOCKER_HOST'] || 'http://localhost'
        PRIVILEGED_COMMANDS = [/^iptables.*/].freeze

        attr_reader :stream_output

        def initialize(stream_output: false)
          @stream_output = stream_output
        end

        def hostname
          URI(DOCKER_HOST).host
        end

        def login(username:, password:, registry:)
          Docker::Command.execute(%(login --username "#{username}" --password "#{password}" #{registry}),
            mask_secrets: password)
        end

        def pull(image:, tag: nil, quiet: true)
          Docker::Command.new("pull").tap do |command|
            command << "-q" if quiet
            command << full_image_name(image, tag)

            command.execute!
          end
        end

        def run(image:, tag: nil, args: [], mask_secrets: nil)
          Docker::Command.new('run', stream_output: stream_output, mask_secrets: mask_secrets).tap do |command|
            yield command if block_given?

            command << full_image_name(image, tag)
            command << args if args.any?

            command.execute!
          end
        end

        def privileged_command?(command)
          PRIVILEGED_COMMANDS.each do |privileged_regex|
            return true if command.match(privileged_regex)
          end

          false
        end

        # Write to file(s) in the Docker container specified by @param name
        # @param name The name of the Docker Container
        # @example
        #   engine.write_files('gitlab-abc123') do |files|
        #     files.append('/etc/hosts', '127.0.0.1 localhost')
        #     files.write('/opt/other', <<~TEXT
        #       This is content
        #       That goes within /opt/other
        #     TEXT)
        def write_files(name, mask_secrets: nil)
          exec(name, yield(
            Class.new do
              # @param file The name of the file
              # @param contents The content of the file to write
              # @param expand_vars Set false if you need to write an environment variable '$' to a file.
              # The variable should be escaped \\\$
              def self.write(file, contents, expand_vars = true)
                if expand_vars
                  %(echo "#{contents}" > #{file};)
                else
                  %(echo '#{contents}' > #{file};)
                end
              end

              def self.append(file, contents)
                %(echo "#{contents}" >> #{file};)
              end
            end
          ), mask_secrets: mask_secrets)
        end

        def exec(name, command, mask_secrets: nil, shell: "bash")
          cmd = ['exec']
          cmd << '--privileged' if privileged_command?(command)
          Docker::Command.execute(%(#{cmd.join(' ')} #{name} #{shell} -c "#{command.gsub('"', '\\"')}"),
            mask_secrets: mask_secrets)
        end

        def read_file(image, tag, path, &block)
          cat_file = "run --rm --entrypoint /bin/cat #{full_image_name(image, tag)} #{path}"
          Docker::Command.execute(cat_file, &block)
        end

        def attach(name, &block)
          Docker::Command.execute("attach --sig-proxy=false #{name}", &block)
        end

        def copy(name, src_path, dest_path)
          Docker::Command.execute("cp #{src_path} #{name}:#{dest_path}")
        end

        def restart(name)
          Docker::Command.execute("restart #{name}")
        end

        def stop(name)
          Docker::Command.execute("stop #{name}")
        end

        def remove(name)
          Docker::Command.execute("rm -f #{name}")
        end

        def manifest_exists?(name)
          Docker::Command.execute("manifest inspect #{name}")
        rescue Support::ShellCommand::StatusError
          false
        else
          true
        end

        def container_exists?(name)
          !Docker::Command.execute("container list --all --format '{{.Names}}' --filter name=^#{name}$").empty?
        end

        def network_exists?(name)
          !Docker::Command.execute("network list --format '{{.Name}}' --filter name=^#{name}$").empty?
        end

        def network_create(name)
          Docker::Command.execute("network create #{name}")
        end

        def port(name, port)
          Docker::Command.execute("port #{name} #{port}/tcp")
        end

        def running?(name)
          Docker::Command.execute("ps -f name=#{name}").include?(name)
        end

        def ps(name = nil)
          Docker::Command.execute(['ps', name].compact.join(' '))
        end

        def inspect(name)
          Docker::Command.new('inspect').then do |command|
            yield command if block_given?

            command << name

            command.execute!
          end
        end

        private

        def full_image_name(image, tag)
          [image, tag].compact.join(':')
        end
      end
    end
  end
end
