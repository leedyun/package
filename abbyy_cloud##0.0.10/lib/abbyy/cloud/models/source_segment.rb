require_relative "source_tag"

class ABBYY::Cloud
  module Models
    class SourceSegment < Model
      attribute :text, type: Types::Strict::String
      attribute :tags, type: Types::Array.member(Types::SourceTag),
                       default: proc { [] }
    end

    # Registers type Types::SourceSegment
    Types.register_type SourceSegment
  end
end
