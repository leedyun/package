# frozen_string_literal: true

require 'intercom/utils'

module Intercom
  module ApiOperations
    module Archive
      def archive(object)
        @client.delete("/#{collection_name}/#{object.id}", {})
        object
      end

      alias_method 'delete', 'archive'
    end
  end
end
