class ABBYY::Cloud
  module Models
    class UnitType < ::String
      VALUES = %w(Chars Words Pages Documents).freeze

      def self.new(string)
        super Types::Strict::String.constrained(included_in: VALUES)[string]
      end
    end

    # Registers type Types::UnitType
    Types.register_type UnitType
  end
end
