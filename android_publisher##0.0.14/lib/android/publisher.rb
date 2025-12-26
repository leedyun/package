require "android/publisher/version"
require 'android/publisher/connection'
require 'android/publisher/edit'
require 'android/publisher/edit_connection'
require 'android/publisher/response'
require 'android/publisher/secrets'
require 'android/publisher/apks'
require 'android/publisher/track'


module Android
  class Publisher
    def initialize(package_name, apk_path = nil, version_code = nil)
      @package_name           = package_name
      @apk_path               = apk_path
      @version_code           = version_code
    end

    def rollout(user_fraction = 0.01)
      edit.insert
      edit.upload_apk(@apk_path) unless @apk_path.nil?
      current_user_fraction = edit.rollout_fraction
      user_fraction = current_user_fraction if user_fraction < current_user_fraction
      edit.assign_to_staged_rollout_track(user_fraction)
      edit.commit
    end

    def update_rollout(user_fraction)
      edit.insert
      current_user_fraction = edit.rollout_fraction
      user_fraction = current_user_fraction if user_fraction < current_user_fraction
      edit.update_rollout(user_fraction)
      edit.commit
    end

    def finish_rollout
      edit.insert
      edit.assign_to_production_track
      edit.clear_rollout
      edit.commit
    end

    def deploy_to_alpha
      edit.insert
      edit.upload_apk(@apk_path) unless @apk_path.nil?
      edit.assign_to_alpha_track
      edit.commit
    end

    def deploy_to_beta
      edit.insert
      edit.upload_apk(@apk_path) unless @apk_path.nil?
      edit.assign_to_beta_track
      edit.commit
    end

    def deploy_to_production
      edit.insert
      edit.upload_apk(@apk_path) unless @apk_path.nil?
      edit.assign_to_production_track
      edit.commit
    end

    def clear_rollout
      edit.insert
      if edit.track_has_deployed_apks?(:rollout)
        edit.clear_rollout
        edit.commit
      end
    end

    def clear_beta
      edit.insert
      if edit.track_has_deployed_apks?(:beta)
        edit.clear_beta
        edit.commit
      end
    end

    def authorized_connection
      @authorized_connection ||= Android::Publisher::Secrets.load.to_authorized_connection
    end

    def client
      @client ||= Android::Publisher::Connection.new(authorized_connection, @package_name)
    end

    def edit
      @edit ||= Android::Publisher::Edit.new(client, @version_code)
    end
  end
end
