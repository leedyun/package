module Any
  module Validate
    module Uuid

      def valid_uuid? uuid: nil
        return true if uuid =~ /^[\da-f]{8}-([\da-f]{4}-){3}[\da-f]{12}$/i
        return false
      rescue
        return false
      end

    end
  end
end
