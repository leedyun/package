require_relative "base"

class ABBYY::Cloud
  module Operations
    class Translate < Base
      link "https://api.abbyy.cloud/swagger/ui/index#!/Order/Order_Translate"
      path { "v0/order/mt/sync" }
      http_method "post"

      request_body do
        attribute :engine,          type: Types::Strict::String
        attribute :source_language, type: Types::Locale
        attribute :target_language, type: Types::Locale
        attribute :source_text,     type: Types::Strict::String
      end

      response_body Models::Translation
    end
  end
end
