class ABBYY::Cloud
  module Models
    TYPES = %w(Start End Placeholder).freeze

    class SourceTag < Model
      attribute :number,   type: Types::Strict::Int
      attribute :position, type: Types::Strict::Int
      attribute :type,
                type: Types::Strict::String.constrained(included_in: TYPES)
    end

    # Registers type Types::SourceTag
    Types.register_type SourceTag
  end
end
