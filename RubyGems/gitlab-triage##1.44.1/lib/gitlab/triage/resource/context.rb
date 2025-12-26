# frozen_string_literal: true

require_relative 'base'
require_relative 'epic'
require_relative 'issue'
require_relative 'linked_issue'
require_relative 'merge_request'
require_relative 'instance_version'
require_relative 'branch'

module Gitlab
  module Triage
    module Resource
      module Context
        EvaluationError = Class.new(RuntimeError)

        def self.build(resource, **options)
          const_name = (resource[:type] || 'Base')
            .to_s.singularize.camelcase

          Resource.const_get(const_name).new(resource, **options).extend(self)
        end

        def eval(ruby)
          instance_eval <<~RUBY, __FILE__, __LINE__ + 1
            begin
              #{ruby}
            rescue StandardError, ScriptError => e
              raise EvaluationError.new(e.message)
            end
          RUBY
        rescue EvaluationError => e
          # This way we could obtain the original backtrace and error
          # If we just let instance_eval raise an error, the backtrace
          # won't contain the actual line where it's giving an error.
          raise e.cause
        end

        private

        def instance_version
          @instance_version ||= InstanceVersion.new(parent: self)
        end
      end
    end
  end
end
