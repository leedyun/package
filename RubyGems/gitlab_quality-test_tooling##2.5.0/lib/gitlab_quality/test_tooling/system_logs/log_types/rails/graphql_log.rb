# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module SystemLogs
      module LogTypes
        module Rails
          class GraphqlLog < Log
            include SharedFields::Meta

            def initialize(data)
              super('Rails GraphQL', data)
            end

            def summary_fields
              super.concat(
                [
                  :operation_name,
                  :query_string,
                  :variables
                ],
                meta_fields
              )
            end
          end
        end
      end
    end
  end
end
