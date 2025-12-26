# frozen_string_literal: true

require 'active_support/core_ext/object/blank'
require 'securerandom'

module GitlabQuality
  module TestTooling
    module Runtime
      module Env
        extend self
        using Rainbow

        ENV_VARIABLES = {
          'GITLAB_QA_ISSUE_URL' => :qa_issue_url,
          'CI_COMMIT_REF_NAME' => :ci_commit_ref_name,
          'CI_JOB_NAME' => :ci_job_name,
          'CI_JOB_URL' => :ci_job_url,
          'CI_PROJECT_ID' => :ci_project_id,
          'CI_PROJECT_NAME' => :ci_project_name,
          'CI_PROJECT_PATH' => :ci_project_path,
          'CI_PIPELINE_ID' => :ci_pipeline_id,
          'CI_PIPELINE_URL' => :ci_pipeline_url,
          'SLACK_QA_CHANNEL' => :slack_qa_channel,
          'DEPLOY_VERSION' => :deploy_version
        }.freeze

        ENV_VARIABLES.each do |env_name, method_name|
          define_method(method_name) do
            env_var_value_if_defined(env_name) || (instance_variable_get(:"@#{method_name}") if instance_variable_defined?(:"@#{method_name}"))
          end
        end

        def log_level
          env_var_value_if_defined('QA_LOG_LEVEL')&.upcase || 'INFO'
        end

        def gitlab_bot_username
          env_var_value_if_defined('GITLAB_BOT_USERNAME') || 'gitlab-bot'
        end

        def log_path
          env_var_value_if_defined('QA_LOG_PATH') || host_artifacts_dir
        end

        def default_branch
          env_var_value_if_defined('QA_DEFAULT_BRANCH') || 'main'
        end

        def ci_api_v4_url
          env_var_value_if_defined('CI_API_V4_URL') || 'https://gitlab.com/api/v4'
        end

        def gitlab_api_base
          env_var_value_if_defined('GITLAB_API_BASE') || ci_api_v4_url
        end

        def pipeline_from_project_name
          %w[gitlab gitaly].any? { |str| ci_project_name.to_s.start_with?(str) } ? default_branch : ci_project_name
        end

        def run_id
          @run_id ||= "gitlab-qa-run-#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}-#{SecureRandom.hex(4)}"
        end

        def colorized_logs?
          enabled?(ENV.fetch('COLORIZED_LOGS', nil), default: false)
        end

        def deploy_environment
          env_var_value_if_defined('DEPLOY_ENVIRONMENT') || pipeline_from_project_name
        end

        def host_artifacts_dir
          @host_artifacts_dir ||= File.join(
            env_var_value_if_defined('QA_ARTIFACTS_DIR') || '/tmp/gitlab-qa', Runtime::Env.run_id
          )
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

        private

        def enabled?(value, default: true)
          return default if value.nil?

          (value =~ /^(false|no|0)$/i) != 0
        end

        def env_var_value_valid?(variable)
          !ENV[variable].blank?
        end

        def env_var_value_if_defined(variable)
          return ENV.fetch(variable) if env_var_value_valid?(variable)
        end

        def env_var_name_if_defined(variable)
          # Pass through the variables if they are defined and not empty in the environment
          return "$#{variable}" if env_var_value_valid?(variable)
        end
      end
    end
  end
end
