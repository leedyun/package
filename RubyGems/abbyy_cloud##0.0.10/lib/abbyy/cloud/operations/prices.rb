require_relative "base"

class ABBYY::Cloud
  module Operations
    class Prices < Base
      # rubocop: disable Metrics/LineLength
      link "https://api.abbyy.cloud/swagger/ui/index#!/Prices/Prices_GetAccountPrices"
      # rubocop: enable Metrics/LineLength
      path { "v0/prices/details" }
      http_method "get"

      request_query do
        attribute :skip, type: Types::Strict::Int
        attribute :take, type: Types::Strict::Int
        attribute :type, type: Types::Strict::String, optional: true
        attribute :from, type: Types::Locale,         optional: true
        attribute :to,   type: Types::Locale,         optional: true
      end

      response_body Types::Array.member(Types::Price)
    end
  end
end
