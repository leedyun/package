require_relative "transfer_data"

class ABBYY::Cloud
  module Models
    class TranslationSegment < Model
      attribute :id,   type: Types::Strict::String
      attribute :text, type: Types::Strict::String
      attribute :tags_transfer_data,
                type: Types::Array.member(Types::TransferData),
                default: proc { [] }
    end

    # Registers type Types::TranslationSegment
    Types.register_type TranslationSegment
  end
end
