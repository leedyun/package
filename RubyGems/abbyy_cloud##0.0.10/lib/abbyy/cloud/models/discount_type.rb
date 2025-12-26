class ABBYY::Cloud
  module Models
    class DiscountType < ::String
      VALUES = %w(
        TMTextMatch
        TMTaggedTextMatch
        TMHalfContextMatch
        TMFullContextMatch
      ).freeze

      def self.new(string)
        super Types::Strict::String.constrained(included_in: VALUES)[string]
      end
    end

    # Registers type Types::DiscountType
    Types.register_type DiscountType
  end
end
