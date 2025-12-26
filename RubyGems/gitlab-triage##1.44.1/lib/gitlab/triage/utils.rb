# frozen_string_literal: true

module Gitlab
  module Triage
    module Utils
      module_function

      def graphql_quote(string)
        contents = string.to_s.gsub('"', '\\"')

        %("#{contents}")
      end
    end
  end
end
