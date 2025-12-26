require_relative "discount_type"

class ABBYY::Cloud
  module Models
    class Discount < Model
      attribute :discount_type, type: Types::DiscountType
      attribute :discount,      type: Types::Coercible::Float
    end

    # Registers type Types::Discount
    Types.register_type Discount
  end
end
