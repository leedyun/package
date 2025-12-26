# frozen_string_literal: true

module RuboCop
  module Cop
    module Gitlab
      # Checks for string interpolation of sensitive variables
      # in information that's *probably* logged.

      # @example
      #   # bad
      #   <<~OMNIBUS
      #   gitlab_rails['object_store']['objects']['lfs']['bucket'] = '#{Runtime::Env.aws_s3_secret_key}'
      #   OMNIBUS
      #
      #   # good
      #   gitlab_rails['object_store']['objects']['lfs']['bucket'] = '#{Runtime::Env.aws_s3_bucket_name}'

      class DangerousInterpolation < Base
        MSG = 'Sensitive variables should not be logged. ' \
              'Please ensure that the interpolated variable is not sensitive. If not, add it to `ENV_VARIABLES` in the cop class.'

        # These values are taken from /lib/gitlab/qa/runtime/env.rb. Sensitive variables have been removed.
        ENV_VARIABLES = {
          'HOST_ARTIFACT_DIR' => :host_artifacts_dir,
          'QA_IMAGE' => :qa_image,
          'QA_REMOTE_GRID' => :remote_grid,
          'QA_REMOTE_GRID_USERNAME' => :remote_grid_username,
          'QA_REMOTE_GRID_PROTOCOL' => :remote_grid_protocol,
          'QA_REMOTE_MOBILE_DEVICE_NAME' => :remote_mobile_device_name,
          'QA_REMOTE_TUNNEL_ID' => :remote_tunnel_id,
          'QA_BROWSER' => :browser,
          'QA_SELENOID_BROWSER_VERSION' => :selenoid_browser_version,
          'QA_RECORD_VIDEO' => :record_video,
          'QA_LAYOUT' => :layout,
          'QA_VIDEO_RECORDER_IMAGE' => :video_recorder_image,
          'QA_VIDEO_RECORDER_VERSION' => :video_recorder_version,
          'QA_SELENOID_BROWSER_IMAGE' => :selenoid_browser_image,
          'QA_ADDITIONAL_REPOSITORY_STORAGE' => :qa_additional_repository_storage,
          'QA_PRAEFECT_REPOSITORY_STORAGE' => :qa_praefect_repository_storage,
          'QA_GITALY_NON_CLUSTER_STORAGE' => :qa_gitaly_non_cluster_storage,
          'QA_DEBUG' => :qa_debug,
          'QA_CAN_TEST_ADMIN_FEATURES' => :qa_can_test_admin_features,
          'QA_CAN_TEST_GIT_PROTOCOL_V2' => :qa_can_test_git_protocol_v2,
          'QA_CAN_TEST_PRAEFECT' => :qa_can_test_praefect,
          'QA_SIMULATE_SLOW_CONNECTION' => :qa_simulate_slow_connection,
          'QA_SLOW_CONNECTION_LATENCY_MS' => :qa_slow_connection_latency_ms,
          'QA_SLOW_CONNECTION_THROUGHPUT_KBPS' => :qa_slow_connection_throughput_kbps,
          'QA_GENERATE_ALLURE_REPORT' => :generate_allure_report,
          'QA_EXPORT_TEST_METRICS' => :qa_export_test_metrics,
          'QA_INFLUXDB_URL' => :qa_influxdb_url,
          'QA_SKIP_PULL' => :qa_skip_pull,
          'QA_VALIDATE_RESOURCE_REUSE' => :qa_validate_resource_reuse,
          'WEBDRIVER_HEADLESS' => :webdriver_headless,
          'GITLAB_ADMIN_USERNAME' => :admin_username,
          'GITLAB_USERNAME' => :user_username,
          'GITLAB_LDAP_USERNAME' => :ldap_username,
          'GITLAB_FORKER_USERNAME' => :forker_username,
          'GITLAB_USER_TYPE' => :user_type,
          'GITLAB_SANDBOX_NAME' => :gitlab_sandbox_name,
          'GITLAB_URL' => :gitlab_url,
          'SIMPLE_SAML_HOSTNAME' => :simple_saml_hostname,
          'SIMPLE_SAML_FINGERPRINT' => :simple_saml_fingerprint,
          'ACCEPT_INSECURE_CERTS' => :accept_insecure_certs,
          'EE_LICENSE' => :ee_license,
          'GCLOUD_ACCOUNT_EMAIL' => :gcloud_account_email,
          'CLOUDSDK_CORE_PROJECT' => :cloudsdk_core_project,
          'GCLOUD_REGION' => :gcloud_region,
          'SIGNUP_DISABLED' => :signup_disabled,
          'GITLAB_QA_USERNAME_1' => :gitlab_qa_username_1,
          'QA_GITHUB_USERNAME' => :qa_github_username,
          'QA_GITLAB_HOSTNAME' => :qa_gitlab_hostname,
          'QA_GITLAB_USE_TLS' => :qa_gitlab_use_tls,
          'KNAPSACK_GENERATE_REPORT' => :knapsack_generate_report,
          'KNAPSACK_REPORT_PATH' => :knapsack_report_path,
          'KNAPSACK_TEST_FILE_PATTERN' => :knapsack_test_file_pattern,
          'KNAPSACK_TEST_DIR' => :knapsack_test_dir,
          'NO_KNAPSACK' => :no_knapsack,
          'QA_KNAPSACK_REPORT_GCS_CREDENTIALS' => :qa_knapsack_report_gcs_credentials,
          'QA_KNAPSACK_REPORT_PATH' => :qa_knapsack_report_path,
          'QA_RSPEC_REPORT_PATH' => :qa_rspec_report_path,
          'RSPEC_FAST_QUARANTINE_PATH' => :rspec_fast_quarantine_path,
          'RSPEC_SKIPPED_TESTS_REPORT_PATH' => :skipped_tests_report_path,
          'CI' => :ci,
          'CI_JOB_NAME' => :ci_job_name,
          'CI_JOB_NAME_SLUG' => :ci_job_name_slug,
          'CI_JOB_URL' => :ci_job_url,
          'CI_RUNNER_ID' => :ci_runner_id,
          'CI_SERVER_HOST' => :ci_server_host,
          'CI_NODE_INDEX' => :ci_node_index,
          'CI_NODE_TOTAL' => :ci_node_total,
          'CI_PROJECT_NAME' => :ci_project_name,
          'CI_PROJECT_PATH' => :ci_project_path,
          'CI_PIPELINE_SOURCE' => :ci_pipeline_source,
          'CI_PIPELINE_URL' => :ci_pipeline_url,
          'CI_PIPELINE_CREATED_AT' => :ci_pipeline_created_at,
          'CI_MERGE_REQUEST_IID' => :ci_merge_request_iid,
          'COVERBAND_ENABLED' => :coverband_enabled,
          'GITLAB_CI' => :gitlab_ci,
          'ELASTIC_URL' => :elastic_url,
          'GITLAB_QA_LOOP_RUNNER_MINUTES' => :gitlab_qa_loop_runner_minutes,
          'MAILHOG_HOSTNAME' => :mailhog_hostname,
          'GEO_MAX_FILE_REPLICATION_TIME' => :geo_max_file_replication_time,
          'GEO_MAX_DB_REPLICATION_TIME' => :geo_max_db_replication_time,
          'JIRA_HOSTNAME' => :jira_hostname,
          'JIRA_ADMIN_USERNAME' => :jira_admin_username,
          'CACHE_NAMESPACE_NAME' => :cache_namespace_name,
          'GITLAB_QA_USER_AGENT' => :gitlab_qa_user_agent,
          'GEO_FAILOVER' => :geo_failover,
          'GITLAB_TLS_CERTIFICATE' => :gitlab_tls_certificate,
          'AWS_S3_REGION' => :aws_s3_region,
          'AWS_S3_KEY_ID' => :aws_s3_key_id,
          'AWS_S3_BUCKET_NAME' => :aws_s3_bucket_name,
          'TOP_UPSTREAM_MERGE_REQUEST_IID' => :top_upstream_merge_request_iid,
          'GOOGLE_PROJECT' => :google_project,
          'GOOGLE_CLIENT_EMAIL' => :google_client_email,
          'GOOGLE_CDN_LB' => :google_cdn_load_balancer,
          'GOOGLE_CDN_SIGNURL_KEY_NAME' => :google_cdn_signurl_key_name,
          'GCS_CDN_BUCKET_NAME' => :gcs_cdn_bucket_name,
          'GCS_BUCKET_NAME' => :gcs_bucket_name,
          'SMOKE_ONLY' => :smoke_only,
          'CHROME_DISABLE_DEV_SHM' => :chrome_disable_dev_shm,
          'COLORIZED_LOGS' => :colorized_logs,
          'FIPS' => :fips,
          'JH_ENV' => :jh_env,
          'QA_GITHUB_OAUTH_APP_ID' => :github_oauth_app_id,
          'QA_1P_EMAIL' => :qa_1p_email,
          'QA_1P_GITHUB_UUID' => :qa_1p_github_uuid,
          'RELEASE' => :release,
          'RELEASE_REGISTRY_URL' => :release_registry_url,
          'RELEASE_REGISTRY_USERNAME' => :release_registry_username,
          'SELENOID_DIRECTORY' => :selenoid_directory,
          'USE_SELENOID' => :use_selenoid,
          'SCHEDULE_TYPE' => :schedule_type,
          'WORKSPACES_OAUTH_APP_ID' => :workspaces_oauth_app_id,
          'WORKSPACES_PROXY_DOMAIN' => :workspaces_proxy_domain,
          'WORKSPACES_DOMAIN_CERT' => { name: :workspaces_domain_cert, type: :file },
          'WORKSPACES_DOMAIN_KEY' => { name: :workspaces_domain_key, type: :file },
          'WORKSPACES_WILDCARD_CERT' => { name: :workspaces_wildcard_cert, type: :file },
          'WORKSPACES_WILDCARD_KEY' => { name: :workspaces_wildcard_key, type: :file }
        }.freeze

        def_node_matcher :heredoc_interpolation?, <<~PATTERN
          (send (const (const nil? :Runtime) :Env) ...)
        PATTERN

        def on_send(node)
          return unless heredoc_interpolation?(node) && node.parent.parent.dstr_type? && !ENV_VARIABLES.value?(node.source.split(".")[1].to_sym)

          add_offense(node)
        end
      end
    end
  end
end
