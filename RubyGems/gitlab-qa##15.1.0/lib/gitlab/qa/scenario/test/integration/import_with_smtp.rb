# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Test
        module Integration
          # Scenario type for testing importers with smtp enabled in target gitlab instance
          class ImportWithSMTP < Import
            attr_reader :orchestrate_mail_hog_server

            def initialize
              super
              @spec_suite = 'Test::Integration::ImportWithSMTP'
              @orchestrate_mail_hog_server = true
            end

            def configure_omnibus(gitlab, mail_hog)
              gitlab.omnibus_configuration << <<~OMNIBUS
                gitlab_rails['smtp_enable'] = true;
                gitlab_rails['smtp_address'] = '#{mail_hog.hostname}';
                gitlab_rails['smtp_port'] = 1025;
              OMNIBUS
            end
          end
        end
      end
    end
  end
end
