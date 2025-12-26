class ABBYY::Cloud
  module Models
    class Currency < ::String
      FORMAT = /\A[A-Z]{3}\z/

      def self.new(string)
        super Types::Strict::String.constrained(format: FORMAT)[string]
      end
    end

    # Registers type Types::Currency
    Types.register_type Currency
  end
end
