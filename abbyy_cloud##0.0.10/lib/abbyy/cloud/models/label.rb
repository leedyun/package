class ABBYY::Cloud
  module Models
    class Label < ::String
      FORMAT = /\A.{1,80}\z/

      def self.new(string)
        super Types::Strict::String.constrained(format: FORMAT)[string]
      end
    end

    # Registers type Types::Label
    Types.register_type Label
  end
end
