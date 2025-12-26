# frozen_string_literal: true

require 'yaml'

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          class LDAPNoTLS < LDAP
            def initialize
              @gitlab_name = 'gitlab-ldap'
              @spec_suite = 'Test::Integration::LDAPNoTLS'
              @orchestrate_ldap_server = true
              @tls = false
              super
            end

            def configure_omnibus(gitlab)
              gitlab.omnibus_configuration << <<~OMNIBUS
                    gitlab_rails['ldap_enabled'] = true;
                    gitlab_rails['ldap_servers'] = #{ldap_servers_omnibus_config};
                    gitlab_rails['ldap_sync_worker_cron'] = '* * * * *';
                    gitlab_rails['ldap_group_sync_worker_cron'] = '* * * * *';
              OMNIBUS
            end
          end
        end
      end
    end
  end
end
