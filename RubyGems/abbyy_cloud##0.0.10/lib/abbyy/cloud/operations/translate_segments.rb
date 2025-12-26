require_relative "base"

class ABBYY::Cloud
  module Operations
    class TranslateSegments < Base
      # rubocop: disable Metrics/LineLength
      link "https://api.abbyy.cloud/swagger/ui/index#!/Order/Order_TranslateSegments"
      # rubocop: enable Metrics/LineLength
      path { "v1/order/mt/sync" }
      http_method "post"

      request_body do
        attribute :engine,  type: Types::Strict::String
        attribute :from,    type: Types::Locale
        attribute :to,      type: Types::Locale
        attribute :sources, type: Types::Array.member(Types::SourceSegment)
      end

      response_body Types::Array.member(Types::TranslationSegment)
    end
  end
end
