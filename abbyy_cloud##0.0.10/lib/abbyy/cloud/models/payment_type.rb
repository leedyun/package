class ABBYY::Cloud
  module Models
    class PaymentType < ::String
      VALUES = %w(Manual Balance External).freeze

      def self.new(string)
        super Types::Strict::String.constrained(included_in: VALUES)[string]
      end
    end

    # Registers type Types::PaymentType
    Types.register_type PaymentType
  end
end
