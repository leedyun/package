# frozen_string_literal: true

require 'active_support/core_ext/object/blank'

class GitlabDuoSetup
  class << self
    def configure!
      activate_cloud_license

      return unless enabled?('HAS_ADD_ON')

      # The seat links endpoint in CustomersDot is rate limited and can sometimes
      # prevent the service access token from being generated during license activation
      # This generates the token directly, similar to the sync_service_token_worker cron job
      generate_service_access_token

      # Due to the various async Sidekiq processes involved, we wait to verify
      # that the service access token has been generated before proceeding
      verify_service_access_token

      assign_duo_seat_to_admin if enabled?('ASSIGN_SEATS')
    end

    private

    def activate_cloud_license
      puts 'Activating cloud license...'
      result = ::GitlabSubscriptions::ActivateService.new.execute(ENV.fetch('QA_EE_ACTIVATION_CODE'))

      if result[:success]
        puts 'Cloud license activation successful'
      else
        puts 'Cloud license activation failed!'
        puts Array(result[:errors]).join(' ')
        exit 1
      end
    end

    def generate_service_access_token
      puts 'Generating service access token...'

      ::CloudConnector::SyncServiceTokenWorker.perform_async(license_id: License.current.id)
    end

    def token_count
      ::CloudConnector::ServiceAccessToken.active.count
    end

    def verify_service_access_token
      puts 'Waiting for service access token to be available...'

      max_attempts = 3
      attempts = 0

      until token_count&.positive? || attempts == max_attempts
        puts 'Attempting to verify access token exists...'
        attempts += 1
        sleep 30
      end

      return if token_count&.positive?

      puts "Failed to create service access token after #{max_attempts} attempts"
      exit 1
    end

    def assign_duo_seat_to_admin
      result = ::GitlabSubscriptions::UserAddOnAssignments::SelfManaged::CreateService.new(
        add_on_purchase: add_on_purchase, user: admin
      ).execute

      if result.is_a?(ServiceResponse) && result[:status] == :success
        puts 'Seat assignment for admin successful'
      else
        puts 'Seat assignment for admin failed!'

        error = result.is_a?(ServiceResponse) ? result[:message] : result
        puts error
      end
    end

    def enabled?(key, default: nil)
      ENV.fetch(key, default) == 'true'
    end

    def find_add_on_purchase(add_on:)
      GitlabSubscriptions::AddOnPurchase.find_by(add_on: add_on)
    end

    def duo_pro_add_on
      return nil unless GitlabSubscriptions::AddOn.respond_to?(:code_suggestions)

      find_add_on_purchase(add_on: GitlabSubscriptions::AddOn.code_suggestions.last)
    end

    def duo_enterprise_add_on
      return nil unless GitlabSubscriptions::AddOn.respond_to?(:duo_enterprise)

      find_add_on_purchase(add_on: GitlabSubscriptions::AddOn.duo_enterprise.last)
    end

    def admin
      User.find_by(username: 'root')
    end

    def add_on_purchase
      if duo_enterprise_add_on.present?
        puts 'Assigning Duo Enterprise seat to admin...'
        duo_enterprise_add_on
      else
        puts 'Assigning Duo Pro seat to admin...'
        duo_pro_add_on
      end
    end
  end
end

GitlabDuoSetup.configure!
