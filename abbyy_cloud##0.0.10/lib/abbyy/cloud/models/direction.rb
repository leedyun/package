require_relative "locale"

class ABBYY::Cloud
  module Models
    class Direction < Model
      attribute :source, type: Types::Locale
      attribute :target, type: Types::Locale
    end

    # Registers type Types::Direction
    Types.register_type Direction
  end
end
