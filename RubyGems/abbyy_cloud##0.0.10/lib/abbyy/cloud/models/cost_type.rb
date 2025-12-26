class ABBYY::Cloud
  module Models
    class CostType < ::String
      VALUES = %w(Default SomeDiscounts AllDiscounts).freeze

      def self.new(string)
        super Types::Strict::String.constrained(included_in: VALUES)[string]
      end
    end

    # Registers type Types::CostType
    Types.register_type CostType
  end
end
