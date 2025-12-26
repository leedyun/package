# frozen_string_literal: true

module Gitlab
  module QA
    module Scenario
      module Actable
        def act(...)
          instance_exec(...)
        end

        def self.included(base)
          base.extend(ClassMethods)
        end

        module ClassMethods
          def perform
            yield new if block_given?
          end

          def act(...)
            new.act(...)
          end
        end
      end
    end
  end
end
