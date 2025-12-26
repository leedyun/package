# frozen_string_literal: true

require 'gitlab'

module GitlabQuality
  module TestTooling
    module GitlabClient
      class GitlabClient
        RETRY_BACK_OFF_DELAY = 60
        MAX_RETRY_ATTEMPTS = 3

        def initialize(token:, project:, **_kwargs)
          @token = token
          @project = project
          @retry_backoff = 0
        end

        def handle_gitlab_client_exceptions
          yield
        rescue Gitlab::Error::NotFound
          # This error could be raised in assert_user_permission!
          # If so, we want it to terminate at that point
          raise
        rescue SystemCallError, OpenSSL::SSL::SSLError, Net::OpenTimeout, Net::ReadTimeout,
          Gitlab::Error::InternalServerError, Gitlab::Error::BadRequest, Gitlab::Error::ResponseError, Gitlab::Error::Parsing => e
          @retry_backoff += RETRY_BACK_OFF_DELAY

          raise if @retry_backoff > RETRY_BACK_OFF_DELAY * MAX_RETRY_ATTEMPTS

          warn("#{e.class.name} #{e.message}")
          warn("Sleeping for #{@retry_backoff} seconds before retrying...")
          sleep @retry_backoff

          retry
        rescue StandardError => e
          post_exception_to_slack(e) if Runtime::Env.ci_commit_ref_name == Runtime::Env.default_branch

          raise e
        end

        def post_exception_to_slack(error)
          return unless ENV['CI_SLACK_WEBHOOK_URL']

          pipeline = Runtime::Env.pipeline_from_project_name
          channel = case pipeline
                    when "canary"
                      "e2e-run-production"
                    when "staging", "staging-canary"
                      "e2e-run-staging"
                    else
                      "e2e-run-#{pipeline}"
                    end

          slack_options = {
            slack_webhook_url: ENV.fetch('CI_SLACK_WEBHOOK_URL', nil),
            channel: channel,
            username: "GitLab Quality Test Tooling",
            icon_emoji: ':ci_failing:',
            message: <<~MSG
              An unexpected error occurred while reporting test results in issues.
              The error occurred in job: #{Runtime::Env.ci_job_url}
              `#{error.class.name} #{error.message}`
            MSG
          }
          puts "Posting Slack message to channel: #{channel}"

          GitlabQuality::TestTooling::Slack::PostToSlack.new(**slack_options).invoke!
        end

        def ignore_gitlab_client_exceptions
          yield
        rescue StandardError, SystemCallError, OpenSSL::SSL::SSLError, Net::OpenTimeout, Net::ReadTimeout,
          Gitlab::Error::Error => e
          puts "Ignoring the following error: #{e}"
        end

        private

        attr_reader :project, :token

        def client
          @client ||= Gitlab.client(
            endpoint: Runtime::Env.gitlab_api_base,
            private_token: token
          )
        end
      end
    end
  end
end
