class ABBYY::Cloud
  module Models
    class TranslationType < ::String
      VALUES = %w(mt ht_express ht_professional ht_expert).freeze

      def self.new(string)
        super Types::Strict::String.constrained(included_in: VALUES)[string]
      end
    end

    # Registers type Types::TranslationType
    Types.register_type TranslationType
  end
end
