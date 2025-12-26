class ABBYY::Cloud
  module Models
    class OcrQuality < ::String
      VALUES = %w(
        Fast
        Balanced
        Thorough
      ).freeze

      def self.new(string)
        super Types::Strict::String.constrained(included_in: VALUES)[string]
      end
    end

    # Registers type Types::OcrQuality
    Types.register_type OcrQuality
  end
end
