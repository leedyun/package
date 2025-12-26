# frozen_string_literal: true

module Gitlab
  module QA
    module Runtime
      module OmnibusConfigurations
        class GithubOauth < Default
          def configuration
            Runtime::Env.require_github_oauth_environment!

            <<~OMNIBUS
              gitlab_rails['omniauth_enabled'] = true
              gitlab_rails['omniauth_allow_single_sign_on'] = ['github']
              gitlab_rails['omniauth_block_auto_created_users'] = false
              gitlab_rails['omniauth_providers'] = [
                {
                  name: 'github',
                  app_id: '$QA_GITHUB_OAUTH_APP_ID',
                  app_secret: '$QA_GITHUB_OAUTH_APP_SECRET',
                  url: 'https://github.com/',
                  verify_ssl: false,
                  args: { scope: 'user:email' }
                }
              ]
              letsencrypt['enable'] = false
              external_url '<%= gitlab.address %>'
            OMNIBUS
          end
        end
      end
    end
  end
end
