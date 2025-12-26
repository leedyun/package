# frozen_string_literal: true

module Gitlab
  module QA
    module Runtime
      module OmnibusConfigurations
        class DecompositionSingleDb < Default
          def configuration
            <<~OMNIBUS
              gitlab_rails['databases']['main']['enable'] = true
              gitlab_rails['databases']['ci']['enable'] = false
            OMNIBUS
          end
        end
      end
    end
  end
end
