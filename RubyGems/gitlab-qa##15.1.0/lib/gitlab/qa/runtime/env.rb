# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/object/blank'
require 'securerandom'

module Gitlab
  module QA
    module Runtime
      module Env
        extend self
        using Rainbow

        DEFAULT_ADMIN_PASSWORD = '5iveL!fe'

        # Variables that are used in tests and are passed through to the docker container that executes the tests.
        # These variables should be listed in /docs/what_tests_can_be_run.md#supported-gitlab-environment-variables
        # unless they're defined elsewhere (e.g.: https://docs.gitlab.com/ee/ci/variables/predefined_variables.html).
        # Any new key-value pairs should also be added to the hash at /rubocop/cop/gitlab/dangerous_interpolation.rb
        # to prevent Rubocop errors.
        ENV_VARIABLES = {
          'ACCEPT_INSECURE_CERTS' => :accept_insecure_certs,
          'AWS_S3_ACCESS_KEY' => :aws_s3_access_key,
          'AWS_S3_BUCKET_NAME' => :aws_s3_bucket_name,
          'AWS_S3_KEY_ID' => :aws_s3_key_id,
          'AWS_S3_REGION' => :aws_s3_region,
          'CACHE_NAMESPACE_NAME' => :cache_namespace_name,
          'CHROME_DISABLE_DEV_SHM' => :chrome_disable_dev_shm,
          'COVERBAND_ENABLED' => :coverband_enabled,
          'CI' => :ci,
          'CI_JOB_ID' => :ci_job_id,
          'CI_JOB_NAME' => :ci_job_name,
          'CI_JOB_NAME_SLUG' => :ci_job_name_slug,
          'CI_JOB_TOKEN' => :ci_job_token,
          'CI_JOB_URL' => :ci_job_url,
          'CI_MERGE_REQUEST_IID' => :ci_merge_request_iid,
          'CI_NODE_INDEX' => :ci_node_index,
          'CI_NODE_TOTAL' => :ci_node_total,
          'CI_PIPELINE_CREATED_AT' => :ci_pipeline_created_at,
          'CI_PIPELINE_ID' => :ci_pipeline_id,
          'CI_PIPELINE_SOURCE' => :ci_pipeline_source,
          'CI_PIPELINE_URL' => :ci_pipeline_url,
          'CI_PROJECT_NAME' => :ci_project_name,
          'CI_PROJECT_PATH' => :ci_project_path,
          'CI_PROJECT_PATH_SLUG' => :ci_project_path_slug,
          'CI_PROJECT_DIR' => :ci_project_dir,
          'CI_RUNNER_ID' => :ci_runner_id,
          'CI_SERVER_HOST' => :ci_server_host,
          'CI_SERVER_PERSONAL_ACCESS_TOKEN' => :ci_server_personal_access_token,
          'COLORIZED_LOGS' => :colorized_logs,
          'CLOUDSDK_CORE_PROJECT' => :cloudsdk_core_project,
          'EE_LICENSE' => :ee_license,
          'ELASTIC_URL' => :elastic_url,
          'FIPS' => :fips,
          'GCS_BUCKET_NAME' => :gcs_bucket_name,
          'GCS_CDN_BUCKET_NAME' => :gcs_cdn_bucket_name,
          'GCLOUD_ACCOUNT_EMAIL' => :gcloud_account_email,
          'GCLOUD_ACCOUNT_KEY' => :gcloud_account_key,
          'GCLOUD_REGION' => :gcloud_region,
          'GEO_FAILOVER' => :geo_failover,
          'GEO_MAX_DB_REPLICATION_TIME' => :geo_max_db_replication_time,
          'GEO_MAX_FILE_REPLICATION_TIME' => :geo_max_file_replication_time,
          'GITLAB_ADMIN_PASSWORD' => :admin_password,
          'GITLAB_ADMIN_USERNAME' => :admin_username,
          'GITLAB_FORKER_PASSWORD' => :forker_password,
          'GITLAB_FORKER_USERNAME' => :forker_username,
          'GITLAB_LDAP_PASSWORD' => :ldap_password,
          'GITLAB_LDAP_USERNAME' => :ldap_username,
          'GITLAB_PASSWORD' => :user_password,
          'GITLAB_QA_ACCESS_TOKEN' => :qa_access_token,
          'GITLAB_QA_ADMIN_ACCESS_TOKEN' => :qa_admin_access_token,
          'GITLAB_QA_CONTAINER_REGISTRY_ACCESS_TOKEN' => :qa_container_registry_access_token,
          'GITLAB_QA_DEV_ACCESS_TOKEN' => :qa_dev_access_token,
          'GITLAB_QA_FORMLESS_LOGIN_TOKEN' => :gitlab_qa_formless_login_token,
          'GITLAB_QA_LOOP_RUNNER_MINUTES' => :gitlab_qa_loop_runner_minutes,
          'GITLAB_QA_PASSWORD_1' => :gitlab_qa_password_1,
          'GITLAB_QA_PASSWORD_2' => :gitlab_qa_password_2,
          'GITLAB_QA_USER_AGENT' => :gitlab_qa_user_agent,
          'GITLAB_QA_USERNAME_1' => :gitlab_qa_username_1,
          'GITLAB_SANDBOX_NAME' => :gitlab_sandbox_name,
          'GITLAB_TLS_CERTIFICATE' => :gitlab_tls_certificate,
          'GITLAB_URL' => :gitlab_url,
          'GITLAB_USER_TYPE' => :user_type,
          'GITLAB_USERNAME' => :user_username,
          'GITLAB_CI' => :gitlab_ci,
          'GITHUB_ACCESS_TOKEN' => :github_access_token,
          'GOOGLE_CDN_JSON_KEY' => :google_cdn_json_key,
          'GOOGLE_CDN_LB' => :google_cdn_load_balancer,
          'GOOGLE_CDN_SIGNURL_KEY' => :google_cdn_signurl_key,
          'GOOGLE_CDN_SIGNURL_KEY_NAME' => :google_cdn_signurl_key_name,
          'GOOGLE_CLIENT_EMAIL' => :google_client_email,
          'GOOGLE_JSON_KEY' => :google_json_key,
          'GOOGLE_PROJECT' => :google_project,
          'JH_ENV' => :jh_env,
          'JIRA_ADMIN_PASSWORD' => :jira_admin_password,
          'JIRA_ADMIN_USERNAME' => :jira_admin_username,
          'JIRA_HOSTNAME' => :jira_hostname,
          'KNAPSACK_GENERATE_REPORT' => :knapsack_generate_report,
          'KNAPSACK_REPORT_PATH' => :knapsack_report_path,
          'KNAPSACK_TEST_DIR' => :knapsack_test_dir,
          'KNAPSACK_TEST_FILE_PATTERN' => :knapsack_test_file_pattern,
          'MAILHOG_HOSTNAME' => :mailhog_hostname,
          'NO_KNAPSACK' => :no_knapsack,
          'QA_ADDITIONAL_REPOSITORY_STORAGE' => :qa_additional_repository_storage,
          'QA_BROWSER' => :browser,
          'QA_CAN_TEST_ADMIN_FEATURES' => :qa_can_test_admin_features,
          'QA_CAN_TEST_GIT_PROTOCOL_V2' => :qa_can_test_git_protocol_v2,
          'QA_CAN_TEST_PRAEFECT' => :qa_can_test_praefect,
          'QA_COOKIES' => :qa_cookie,
          'QA_DEBUG' => :qa_debug,
          'QA_DOCKER_NETWORK' => :docker_network,
          'QA_EXPORT_TEST_METRICS' => :qa_export_test_metrics,
          'QA_GITALY_NON_CLUSTER_STORAGE' => :qa_gitaly_non_cluster_storage,
          'QA_GITHUB_OAUTH_APP_ID' => :github_oauth_app_id,
          'QA_GITHUB_OAUTH_APP_SECRET' => :github_oauth_app_secret,
          'QA_GITHUB_PASSWORD' => :qa_github_password,
          'QA_GITHUB_USERNAME' => :qa_github_username,
          'QA_GITLAB_HOSTNAME' => :qa_gitlab_hostname,
          'QA_GITLAB_USE_TLS' => :qa_gitlab_use_tls,
          'QA_IMAGE' => :qa_image,
          'QA_INFLUXDB_TOKEN' => :qa_influxdb_token,
          'QA_INFLUXDB_URL' => :qa_influxdb_url,
          'QA_KNAPSACK_REPORT_GCS_CREDENTIALS' => :qa_knapsack_report_gcs_credentials,
          'QA_KNAPSACK_REPORT_PATH' => :qa_knapsack_report_path,
          'QA_LAYOUT' => :layout,
          'QA_PRAEFECT_REPOSITORY_STORAGE' => :qa_praefect_repository_storage,
          'QA_RECORD_VIDEO' => :record_video,
          'QA_REMOTE_GRID' => :remote_grid,
          'QA_REMOTE_GRID_ACCESS_KEY' => :remote_grid_access_key,
          'QA_REMOTE_GRID_PROTOCOL' => :remote_grid_protocol,
          'QA_REMOTE_GRID_USERNAME' => :remote_grid_username,
          'QA_REMOTE_MOBILE_DEVICE_NAME' => :remote_mobile_device_name,
          'QA_REMOTE_TUNNEL_ID' => :remote_tunnel_id,
          'QA_RSPEC_REPORT_PATH' => :qa_rspec_report_path,
          'QA_SELENOID_BROWSER_IMAGE' => :selenoid_browser_image,
          'QA_SELENOID_BROWSER_VERSION' => :selenoid_browser_version,
          'QA_SIMULATE_SLOW_CONNECTION' => :qa_simulate_slow_connection,
          'QA_SKIP_PULL' => :qa_skip_pull,
          'QA_SLOW_CONNECTION_LATENCY_MS' => :qa_slow_connection_latency_ms,
          'QA_SLOW_CONNECTION_THROUGHPUT_KBPS' => :qa_slow_connection_throughput_kbps,
          'QA_VALIDATE_RESOURCE_REUSE' => :qa_validate_resource_reuse,
          'QA_VIDEO_RECORDER_IMAGE' => :video_recorder_image,
          'QA_VIDEO_RECORDER_VERSION' => :video_recorder_version,
          'QA_1P_EMAIL' => :qa_1p_email,
          'QA_1P_GITHUB_UUID' => :qa_1p_github_uuid,
          'QA_1P_PASSWORD' => :qa_1p_password,
          'QA_1P_SECRET' => :qa_1p_secret,
          'RELEASE' => :release,
          'RELEASE_REGISTRY_PASSWORD' => :release_registry_password,
          'RELEASE_REGISTRY_URL' => :release_registry_url,
          'RELEASE_REGISTRY_USERNAME' => :release_registry_username,
          'RSPEC_FAST_QUARANTINE_PATH' => :rspec_fast_quarantine_path,
          'RSPEC_SKIPPED_TESTS_REPORT_PATH' => :skipped_tests_report_path,
          'SCHEDULE_TYPE' => :schedule_type,
          'SELENOID_DIRECTORY' => :selenoid_directory,
          'SIGNUP_DISABLED' => :signup_disabled,
          'SIMPLE_SAML_FINGERPRINT' => :simple_saml_fingerprint,
          'SIMPLE_SAML_HOSTNAME' => :simple_saml_hostname,
          'SMOKE_ONLY' => :smoke_only,
          'TOP_UPSTREAM_MERGE_REQUEST_IID' => :top_upstream_merge_request_iid,
          'USE_SELENOID' => :use_selenoid,
          'WEBDRIVER_HEADLESS' => :webdriver_headless,
          'WORKSPACES_DOMAIN_CERT' => { name: :workspaces_domain_cert, type: :file },
          'WORKSPACES_DOMAIN_KEY' => { name: :workspaces_domain_key, type: :file },
          'WORKSPACES_OAUTH_APP_ID' => :workspaces_oauth_app_id,
          'WORKSPACES_OAUTH_APP_SECRET' => :workspaces_oauth_app_secret,
          'WORKSPACES_OAUTH_SIGNING_KEY' => :workspaces_oauth_signing_key,
          'WORKSPACES_PROXY_DOMAIN' => :workspaces_proxy_domain,
          'WORKSPACES_WILDCARD_CERT' => { name: :workspaces_wildcard_cert, type: :file },
          'WORKSPACES_WILDCARD_KEY' => { name: :workspaces_wildcard_key, type: :file },
          'EPIC_SYNC_TEST' => :epic_sync_test
        }.freeze

        def variables
          defined_variables = ENV_VARIABLES.each_with_object({}) do |(env_var_name, attributes), vars|
            method_name, value = method_name_and_value(env_var_name, attributes, name_as_value: true)
            value ||= send(method_name) # rubocop:disable GitlabSecurity/PublicSend
            vars[env_var_name] = value if value
          end
          qa_variables = ENV.each_with_object({}) do |(name, _value), vars|
            next unless name.start_with?('QA_')

            var_name = env_var_name_if_defined(name)
            vars[name] = var_name if var_name
          end

          qa_variables.merge(defined_variables)
        end

        def admin_password
          ENV['GITLAB_ADMIN_PASSWORD'] || DEFAULT_ADMIN_PASSWORD
        end

        # Variables that should be masked
        #
        # @return [Array] the values of the variables that should be masked
        def variables_to_mask
          # Consider all file variables to need masking by default because they're likely to be secrets
          variables.select { |k, _| ENV_VARIABLES[k].is_a?(Hash) && ENV_VARIABLES[k][:type] == :file }.values
        end

        def debug?
          enabled?(ENV.fetch('QA_DEBUG', nil), default: true)
        end

        def log_level
          env_var_value_if_defined('QA_LOG_LEVEL')&.upcase || 'INFO'
        end

        def log_path
          env_var_value_if_defined('QA_LOG_PATH') || host_artifacts_dir
        end

        def gitlab_availability_timeout
          (env_var_value_if_defined('GITLAB_QA_AVAILABILITY_TIMEOUT') || 360).to_i
        end

        def gitlab_username
          env_var_value_if_defined('GITLAB_USERNAME') || 'gitlab-qa'
        end

        def gitlab_dev_username
          env_var_value_if_defined('GITLAB_DEV_USERNAME') || 'gitlab-qa-bot'
        end

        def run_id
          @run_id ||= "gitlab-qa-run-#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}-#{SecureRandom.hex(4)}"
        end

        def colorized_logs?
          enabled?(ENV.fetch('COLORIZED_LOGS', nil), default: false)
        end

        def dev_access_token_variable
          env_var_name_if_defined('GITLAB_QA_DEV_ACCESS_TOKEN')
        end

        def host_artifacts_dir
          @host_artifacts_dir ||= File.join(
            env_var_value_if_defined('QA_ARTIFACTS_DIR') || '/tmp/gitlab-qa', Runtime::Env.run_id
          )
        end

        def elastic_version
          env_var_value_if_defined('ELASTIC_VERSION') || '8.2.0'
        end

        def opensearch_version
          env_var_value_if_defined('OPENSEARCH_VERSION') || '2.0.1'
        end

        def require_license!
          return if ENV.include?('EE_LICENSE')

          raise ArgumentError, 'GitLab License is not available. Please load a license into EE_LICENSE env variable.'
        end

        def require_no_license!
          return unless ENV.include?('EE_LICENSE')

          raise ArgumentError, "Unexpected EE_LICENSE provided. Please unset it to continue."
        end

        def require_qa_access_token!
          return unless env_var_value_if_defined('GITLAB_QA_ACCESS_TOKEN').to_s.strip.empty?

          raise ArgumentError, "Please provide GITLAB_QA_ACCESS_TOKEN"
        end

        def require_qa_dev_access_token!
          return unless env_var_value_if_defined('GITLAB_QA_DEV_ACCESS_TOKEN').to_s.strip.empty?

          raise ArgumentError, "Please provide GITLAB_QA_DEV_ACCESS_TOKEN"
        end

        def require_qa_container_registry_access_token!
          return unless env_var_value_if_defined('GITLAB_QA_CONTAINER_REGISTRY_ACCESS_TOKEN').to_s.strip.empty?

          raise ArgumentError, "Please provide GITLAB_QA_CONTAINER_REGISTRY_ACCESS_TOKEN"
        end

        def require_aws_s3_environment!
          %w[AWS_S3_REGION AWS_S3_KEY_ID AWS_S3_ACCESS_KEY AWS_S3_BUCKET_NAME].each do |env_key|
            unless ENV.key?(env_key)
              raise ArgumentError,
                "Environment variable #{env_key} must be set to run AWS S3 object storage specs"
            end
          end
        end

        def require_gcs_environment!
          %w[GOOGLE_PROJECT GOOGLE_CLIENT_EMAIL GOOGLE_JSON_KEY GCS_BUCKET_NAME].each do |env_key|
            unless ENV.key?(env_key)
              raise ArgumentError,
                "Environment variable #{env_key} must be set to run GCS object storage specs"
            end
          end
        end

        def require_gcs_with_cdn_environment!
          %w[GOOGLE_CDN_JSON_KEY GCS_CDN_BUCKET_NAME GOOGLE_CDN_LB GOOGLE_CDN_SIGNURL_KEY
            GOOGLE_CDN_SIGNURL_KEY_NAME].each do |env_key|
            unless ENV.key?(env_key)
              raise ArgumentError,
                "Environment variable #{env_key} must be set to run GCS with CDN enabled scenario"
            end
          end
        end

        def require_oauth_environment!
          %w[QA_GITHUB_OAUTH_APP_ID QA_GITHUB_OAUTH_APP_SECRET QA_GITHUB_USERNAME
            QA_GITHUB_PASSWORD QA_1P_EMAIL QA_1P_PASSWORD QA_1P_SECRET QA_1P_GITHUB_UUID].each do |env_key|
            unless ENV.key?(env_key)
              raise ArgumentError,
                "Environment variable #{env_key} must be set to run OAuth specs"
            end
          end
        end

        def require_github_oauth_environment!
          %w[QA_GITHUB_OAUTH_APP_ID QA_GITHUB_OAUTH_APP_SECRET QA_GITHUB_USERNAME
            QA_GITHUB_PASSWORD QA_1P_EMAIL QA_1P_PASSWORD QA_1P_SECRET QA_1P_GITHUB_UUID].each do |env_key|
            unless ENV.key?(env_key)
              raise ArgumentError,
                "Environment variable #{env_key} must be set to run OAuth specs"
            end
          end
        end

        def require_cloud_connector_base_url!
          return unless cloud_connector_base_url.blank?

          raise ArgumentError, "Please provide CLOUD_CONNECTOR_BASE_URL"
        end

        def skip_pull?
          enabled?(env_var_value_if_defined('QA_SKIP_PULL'), default: false)
        end

        def qa_gitlab_use_tls?
          enabled?(env_var_value_if_defined('QA_GITLAB_USE_TLS'), default: false)
        end

        def geo_failover?
          enabled?(env_var_value_if_defined('GEO_FAILOVER'), default: false)
        end

        def qa_export_test_metrics?
          enabled?(env_var_value_if_defined('QA_EXPORT_TEST_METRICS'), default: true)
        end

        def selenoid_directory
          env_var_value_if_defined('SELENOID_DIRECTORY') || "#{host_artifacts_dir}/selenoid"
        end

        def use_selenoid?
          enabled?(env_var_value_if_defined('USE_SELENOID'), default: false)
        end

        def mobile_layout?
          env_var_value_if_defined('QA_LAYOUT')&.match?(/tablet|phone/i)
        end

        def video_recorder_image
          env_var_value_if_defined('QA_VIDEO_RECORDER_IMAGE') ||
            'registry.gitlab.com/gitlab-org/gitlab-qa/selenoid-manual-video-recorder'
        end

        def video_recorder_version
          env_var_value_if_defined('QA_VIDEO_RECORDER_VERSION') || 'latest'
        end

        def selenoid_browser_image
          env_var_value_if_defined('QA_SELENOID_BROWSER_IMAGE') || 'selenoid/chrome'
        end

        def selenoid_browser_version
          env_var_value_if_defined('QA_SELENOID_BROWSER_VERSION') || '111.0'
        end

        def qa_run_type
          return env_var_value_if_defined('QA_RUN_TYPE') if env_var_value_valid?('QA_RUN_TYPE')

          live_envs = %w[staging staging-canary staging-ref canary preprod production]
          return unless live_envs.include?(ci_project_name)

          test_subset = if env_var_value_if_defined('SMOKE_ONLY') == 'true'
                          'sanity'
                        else
                          'full'
                        end

          "#{ci_project_name}-#{test_subset}"
        end

        # The default network for the Docker containers
        #
        # @example <component>.test
        def docker_network
          env_var_value_if_defined('QA_DOCKER_NETWORK') || 'test'
        end

        def docker_add_hosts
          (env_var_value_if_defined('QA_DOCKER_ADD_HOSTS') || '').split(',')
        end

        def jh_env?
          enabled?(env_var_value_if_defined('JH_ENV'), default: false)
        end

        def qa_dev_registry
          env_var_value_if_defined('QA_DEV_REGISTRY') || 'dev.gitlab.org:5005'
        end

        def qa_com_registry
          env_var_value_if_defined('QA_COM_REGISTRY') || 'registry.gitlab.com'
        end

        def gitlab_license_mode
          env_var_value_if_defined('GITLAB_LICENSE_MODE')
        end

        def customer_portal_url
          env_var_value_if_defined('CUSTOMER_PORTAL_URL') || 'https://customers.staging.gitlab.com'
        end

        def cloud_connector_base_url
          env_var_value_if_defined('CLOUD_CONNECTOR_BASE_URL')
        end

        def ee_activation_code
          env_var_value_if_defined('QA_EE_ACTIVATION_CODE')
        end

        def geo_staging_url
          env_var_value_if_defined('GEO_STAGING_URL') || 'https://geo.staging.gitlab.com'
        end

        def staging_url
          env_var_value_if_defined('STAGING_URL') || 'https://staging.gitlab.com'
        end

        def staging_ref_url
          env_var_value_if_defined('STAGING_REF_URL') || 'https://staging-ref.gitlab.com'
        end

        def geo_staging_ref_url
          env_var_value_if_defined('GEO_STAGING_REF_URL') || 'https://geo.staging-ref.gitlab.com'
        end

        def release_url
          env_var_value_if_defined('RELEASE_URL') || 'https://release.gitlab.net'
        end

        def production_url
          env_var_value_if_defined('PRODUCTION_URL') || 'https://gitlab.com'
        end

        def preprod_url
          env_var_value_if_defined('PREPROD_URL') || 'https://pre.gitlab.com'
        end

        def allow_separate_ci_database
          enabled?(env_var_value_if_defined('GITLAB_ALLOW_SEPARATE_CI_DATABASE'), default: false)
        end

        def coverband_enabled?
          enabled?(env_var_value_if_defined('COVERBAND_ENABLED'), default: false)
        end

        def mock_github_enabled?
          enabled?(env_var_value_if_defined('QA_MOCK_GITHUB'), default: true)
        end

        def retry_failed_specs?
          enabled?(env_var_value_if_defined('QA_RETRY_FAILED_SPECS'), default: false)
        end

        def self.qa_gitaly_transactions_enabled?
          enabled?(env_var_value_if_defined('QA_GITALY_TRANSACTIONS_ENABLED'), default: false)
        end

        private

        def enabled?(value, default: true)
          return default if value.nil?

          (value =~ /^(false|no|0)$/i) != 0
        end

        def env_var_value_valid?(variable)
          !ENV[variable].blank?
        end

        def env_var_value_if_defined(variable)
          return ENV.fetch(variable, nil) if env_var_value_valid?(variable)
        end

        def env_var_name_if_defined(variable)
          # Pass through the variables if they are defined and not empty in the environment
          return "$#{variable}" if env_var_value_valid?(variable)
        end

        def method_name_and_value(env_var_name, attributes, name_as_value: false)
          method_name, type = method_name_and_type(attributes)

          # Variables that are overridden in the environment take precedence
          # over the defaults specified by the QA runtime.
          value = if type == :file
                    # If it's a file variable we pass the content of the file to avoid trying to access an invalid
                    # path from inside the specs Docker container
                    path = env_var_value_if_defined(env_var_name)
                    if path.present?
                      full_path = File.expand_path(path)
                      File.read(full_path).strip if full_path && File.exist?(full_path)
                    end
                  elsif name_as_value
                    env_var_name_if_defined(env_var_name)
                  else
                    env_var_value_if_defined(env_var_name)
                  end

          [method_name, value]
        end

        def method_name_and_type(attributes)
          if attributes.is_a?(Hash) && attributes[:type] == :file
            [attributes[:name], :file]
          else
            [attributes, :env_var]
          end
        end

        # Define methods for each variable last so we can use the methods defined just above
        ENV_VARIABLES.each do |env_var_name, attributes|
          method_name, _ = method_name_and_type(attributes)
          next if method_defined?(method_name) # Don't replace methods that were explicitly defined above

          writer_names = attr_writer(method_name)
          define_method(method_name) do
            _, value = method_name_and_value(env_var_name, attributes)
            value || (instance_variable_get("@#{method_name}") if instance_variable_defined?("@#{method_name}"))
          end
          public(*writer_names, method_name)
        end
      end
    end
  end
end
