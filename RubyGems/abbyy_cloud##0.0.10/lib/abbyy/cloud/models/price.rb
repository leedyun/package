require_relative "locale"
require_relative "unit_price"
require_relative "discount"

class ABBYY::Cloud
  module Models
    # Price details
    class Price < Model
      attribute :id,          type: Types::Strict::String
      attribute :account_id,  type: Types::Strict::String, optional: true
      attribute :type,        type: Types::Strict::String
      attribute :from,        type: Types::Locale
      attribute :to,          type: Types::Locale
      attribute :unit_prices, type: Types::Array.member(Types::UnitPrice)
      attribute :discounts,   type: Types::Array.member(Types::Discount)
      attribute :created,     type: Types::Coercible::Time
    end

    # Registers type Types::Price
    Types.register_type Price
  end
end
