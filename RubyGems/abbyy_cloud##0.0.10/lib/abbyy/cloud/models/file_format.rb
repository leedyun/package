class ABBYY::Cloud
  module Models
    class FileFormat < ::String
      VALUES = %w(
        Doc
        Docx
        Rtf
        Txt
      ).freeze

      def self.new(string)
        super Types::Strict::String.constrained(included_in: VALUES)[string]
      end
    end

    # Registers type Types::FileFormat
    Types.register_type FileFormat
  end
end
