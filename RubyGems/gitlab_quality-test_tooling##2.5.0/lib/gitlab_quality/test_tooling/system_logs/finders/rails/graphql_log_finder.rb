# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module SystemLogs
      module Finders
        module Rails
          class GraphqlLogFinder < JsonLogFinder
            def initialize(base_path, file_path = 'gitlab-rails/graphql_json.log')
              super(base_path, file_path)
            end

            def new_log(data)
              LogTypes::Rails::GraphqlLog.new(data)
            end
          end
        end
      end
    end
  end
end
