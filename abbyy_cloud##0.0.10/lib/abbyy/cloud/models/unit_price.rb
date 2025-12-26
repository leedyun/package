require_relative "currency"
require_relative "unit_type"

class ABBYY::Cloud
  module Models
    # Price details
    class UnitPrice < Model
      attribute :unit_type, type: Types::UnitType
      attribute :currency,  type: Types::Currency
      attribute :amount,    type: Types::Coercible::Float
    end

    # Registers type Types::UnitPrice
    Types.register_type UnitPrice
  end
end
