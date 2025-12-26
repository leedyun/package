# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module SystemLogs
      module LogTypes
        module Rails
          class ExceptionLog < Log
            include SharedFields::Exception

            def initialize(data)
              super('Rails Exceptions', data)
            end

            def summary_fields
              super.concat(exception_fields)
            end
          end
        end
      end
    end
  end
end
