# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module SystemLogs
      module LogTypes
        module Rails
          class ApplicationLog < Log
            include SharedFields::Exception
            include SharedFields::Meta

            def initialize(data)
              super('Rails Application', data)
            end

            def summary_fields
              super.concat(
                exception_fields,
                meta_fields
              )
            end
          end
        end
      end
    end
  end
end
