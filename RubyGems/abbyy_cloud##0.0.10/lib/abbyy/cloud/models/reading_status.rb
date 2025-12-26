class ABBYY::Cloud
  module Models
    class ReadingStatus < ::String
      VALUES = %w(
        New
        Submitted
        InProgress
        Done
        Error
      ).freeze

      def self.new(string)
        super Types::Strict::String.constrained(included_in: VALUES)[string]
      end
    end

    # Registers type Types::ReadingStatus
    Types.register_type ReadingStatus
  end
end
