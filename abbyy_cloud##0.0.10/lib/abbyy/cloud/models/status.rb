class ABBYY::Cloud
  module Models
    class Status < ::String
      VALUES = %w(
        New
        Submitted
        PaymentRequired
        Paid
        InProgress
        Done
        Failed
        Accepted
        ReworkRequired
        Canceled
      ).freeze

      def self.new(string)
        super Types::Strict::String.constrained(included_in: VALUES)[string]
      end
    end

    # Registers type Types::Status
    Types.register_type Status
  end
end
