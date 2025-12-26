require_relative "base"

class ABBYY::Cloud
  module Namespaces
    # Namespace for operations with orders
    # @see [https://api.abbyy.cloud/swagger/ui/index#!/Orders] ABBYY Cloud API
    class Orders < Base
      def create(options)
        Operations::SubmitOrder.new(settings).call(options)
      end

      def find(id)
        Operations::FindOrder.new(settings).call(id: id)
      end
    end
  end
end
