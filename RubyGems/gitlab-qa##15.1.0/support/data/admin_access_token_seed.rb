# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/numeric/time'

class AdminAccessTokenSeed
  TOKEN_VALUE = 'ypCa3Dzb23o5nvsixwPA'
  SCOPES = Gitlab::Auth.all_available_scopes

  def self.seed!
    admin_user = User.find_by(username: 'root')

    token_params = {
      scopes: SCOPES.map(&:to_s),
      name: 'admin-api-token',
      expires_at: 3.days.from_now
    }

    admin_user.personal_access_tokens.build(token_params).tap do |pat|
      pat.set_token(TOKEN_VALUE)
      pat.organization = Organizations::Organization.default_organization if Gitlab.version_info >= Gitlab::VersionInfo.new(17, 4)
      pat.save!
    end

    puts 'Personal access token seeded for root user.'
  end
end

AdminAccessTokenSeed.seed!
