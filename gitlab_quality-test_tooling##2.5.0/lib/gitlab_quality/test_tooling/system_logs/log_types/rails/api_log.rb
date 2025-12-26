# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module SystemLogs
      module LogTypes
        module Rails
          class ApiLog < Log
            include SharedFields::Exception
            include SharedFields::Meta

            def initialize(data)
              super('Rails API', data)
            end

            def summary_fields
              super.concat(
                [
                  :method,
                  :path,
                  :status,
                  :params,
                  :api_error
                ],
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
