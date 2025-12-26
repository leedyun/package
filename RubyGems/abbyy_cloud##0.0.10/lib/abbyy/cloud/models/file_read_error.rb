class ABBYY::Cloud
  module Models
    class FileReadError < ::String
      VALUES = %w(
        Unsupported
        FileEmpty
        FileEncrypted
        FileFormatError
        UnknownError
      ).freeze

      def self.new(string)
        super Types::Strict::String.constrained(included_in: VALUES)[string]
      end
    end

    # Registers type Types::FileReadError
    Types.register_type FileReadError
  end
end
