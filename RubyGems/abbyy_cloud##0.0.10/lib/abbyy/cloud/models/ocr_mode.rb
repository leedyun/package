class ABBYY::Cloud
  module Models
    class OcrMode < ::String
      VALUES = %w(
        EditableCopy
        ExactCopy
        FormattedText
        PlainText
      ).freeze

      def self.new(string)
        super Types::Strict::String.constrained(included_in: VALUES)[string]
      end
    end

    # Registers type Types::OcrMode
    Types.register_type OcrMode
  end
end
