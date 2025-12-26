class ABBYY::Cloud
  module Models
    class OcrStatistics < Model
      attribute :exported_pages,       type: Types::Coercible::Int
      attribute :total_characters,     type: Types::Coercible::Int
      attribute :uncertain_characters, type: Types::Coercible::Int
      attribute :success_part,         type: Types::Coercible::Float
    end

    # Registers type Types::OcrStatistics
    Types.register_type OcrStatistics
  end
end
