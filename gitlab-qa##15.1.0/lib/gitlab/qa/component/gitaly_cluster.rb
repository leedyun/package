# frozen_string_literal: true

module Gitlab
  module QA
    module Component
      class GitalyCluster
        class GitalyClusterConfig
          attr_accessor :gitlab_name, :network, :airgapped_network,
            :praefect_node_name, :praefect_port, :praefect_ip,
            :primary_node_name, :primary_node_port,
            :secondary_node_name, :secondary_node_port,
            :tertiary_node_name, :tertiary_node_port,
            :database_node_name, :database_port

          attr_reader :praefect_addr, :primary_node_addr, :secondary_node_addr, :tertiary_node_addr, :database_node_addr

          def initialize(params = {}) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
            @gitlab_name = params[:gitlab_name] || 'gitlab-gitaly-cluster'
            @network = params[:network] || Runtime::Env.docker_network
            @airgapped_network = params[:airgapped_network] || false

            @praefect_node_name = params[:praefect_node_name] || 'praefect'
            @praefect_port = params[:praefect_port] || 2305

            @primary_node_name = params[:primary_node_name] || 'gitaly1'
            @primary_node_port = params[:primary_node_port] || 8075

            @secondary_node_name = params[:secondary_node_name] || 'gitaly2'
            @secondary_node_port = params[:secondary_node_port] || 8075

            @tertiary_node_name = params[:tertiary_node_name] || 'gitaly3'
            @tertiary_node_port = params[:tertiary_node_port] || 8075

            @database_node_name = params[:database_node_name] || 'postgres'
            @database_port = params[:database_port] || 5432

            @praefect_addr = "#{praefect_node_name}.#{network}"
            @primary_node_addr = "#{primary_node_name}.#{network}"
            @secondary_node_addr = "#{secondary_node_name}.#{network}"
            @tertiary_node_addr = "#{tertiary_node_name}.#{network}"
            @database_node_addr = "#{database_node_name}.#{network}"
          end
        end

        include Scenario::Actable
        using Rainbow

        attr_accessor :release, :exec_commands, :gitlab_name, :config
        attr_reader :gitaly_primary_node, :gitaly_secondary_node, :gitaly_tertiary_node, :praefect_node, :database_node

        def initialize(config = GitalyClusterConfig.new)
          @spec_suite = 'Test::Instance::All'
          @env = {}
          @tag = 'gitaly_cluster'
          @release = 'EE'
          @config = config
        end

        # @param [Boolean] parallel_gitaly controls whether we start gitaly nodes in parallel to improve startup time
        def instance(parallel_gitaly = false)
          run_gitaly_cluster(QA::Release.new(release), parallel_gitaly)
        end

        # @param [Boolean] parallel_gitaly controls whether we start gitaly nodes in parallel to improve startup time
        def run_gitaly_cluster(release, parallel_gitaly = false)
          # This also ensure that the docker network is created here, avoiding any potential race conditions later
          #  if the gitaly-cluster and GitLab containers attempt to create a network in parallel
          @database_node = postgres

          Thread.new do
            Thread.current.abort_on_exception = true
            start_gitaly_cluster(release, parallel_gitaly)
          end
        end

        # @param [Boolean] parallel_gitaly controls whether we start gitaly nodes in parallel to improve startup time
        def start_gitaly_cluster(release, parallel_gitaly = false) # rubocop:disable Metrics/AbcSize
          Runtime::Logger.info("Starting Gitaly Cluster")

          if parallel_gitaly
            threads = []
            threads << Thread.new do
              @gitaly_primary_node = gitaly(config.primary_node_name, config.primary_node_port, release)
            end
            threads << Thread.new do
              @gitaly_secondary_node = gitaly(config.secondary_node_name, config.secondary_node_port, release)
            end
            threads << Thread.new do
              @gitaly_tertiary_node = gitaly(config.tertiary_node_name, config.tertiary_node_port, release)
            end
            threads.each(&:join)
          else
            @gitaly_primary_node = gitaly(config.primary_node_name, config.primary_node_port, release)
            @gitaly_secondary_node = gitaly(config.secondary_node_name, config.secondary_node_port, release)
            @gitaly_tertiary_node = gitaly(config.tertiary_node_name, config.tertiary_node_port, release)
          end

          @praefect_node = praefect(release)
          config.praefect_ip = praefect_node.ip_address
          Runtime::Logger.info("Gitaly Cluster Ready")
        end

        def postgres
          Component::PostgreSQL.new.tap do |sql|
            sql.name = config.database_node_name
            sql.airgapped_network = config.airgapped_network
            sql.network = config.network
            sql.instance(skip_teardown: true) do
              sql.run_psql '-d template1 -c "CREATE DATABASE praefect_production OWNER postgres"'
            end
          end
        end

        def gitaly(gitaly_name, port, release) # rubocop:disable Metrics/AbcSize
          Component::Gitaly.new.tap do |gitaly|
            gitaly.cluster_config = config
            gitaly.release = release
            gitaly.name = gitaly_name
            gitaly.gitaly_port = port
            gitaly.airgapped_network = config.airgapped_network
            gitaly.network = config.network
            gitaly.gitlab_name = config.gitlab_name
            gitaly.instance(skip_teardown: true)
          end
        end

        def praefect(release)
          Component::Praefect.new.tap do |praefect|
            praefect.cluster_config = config
            praefect.name = config.praefect_node_name
            praefect.airgapped_network = config.airgapped_network
            praefect.network = config.network
            praefect.release = release
            praefect.instance(skip_teardown: true)
          end
        end

        # Helper configuration for omnibus config to disable all non GitalyCluster related omnibus services
        def self.disable_other_omnibus_services
          <<~OMNIBUS
            postgresql['enable'] = false;
            redis['enable'] = false;
            nginx['enable'] = false;
            puma['enable'] = false;
            sidekiq['enable'] = false;
            gitlab_workhorse['enable'] = false;
            gitlab_rails['rake_cache_clear'] = false;
            gitlab_rails['auto_migrate'] = false;
            gitlab_exporter['enable'] = false;
            gitlab_kas['enable'] = false;
          OMNIBUS
        end
      end
    end
  end
end
