require_relative "base"

class ABBYY::Cloud
  module Operations
    class FindOrder < Base
      link "https://api.abbyy.cloud/swagger/ui/index#!/Order/Order_GetOrder"
      path { "v0/order/#{id}" }
      http_method "get"

      response_body Models::FullOrder
    end
  end
end
