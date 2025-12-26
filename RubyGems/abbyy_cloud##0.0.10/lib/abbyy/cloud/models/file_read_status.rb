class ABBYY::Cloud
  module Models
    class FileReadStatus < ::String
      VALUES = %w(New Submitted InProgress Done Error).freeze

      def self.new(string)
        super Types::Strict::String.constrained(included_in: VALUES)[string]
      end
    end

    # Registers type Types::FileReadStatus
    Types.register_type FileReadStatus
  end
end
