require_relative "ocr_warning_type"

class ABBYY::Cloud
  module Models
    class OcrWarning < Model
      attribute :warning_type,         type: Types::OcrWarningType
      attribute :page_number,          type: Types::Coercible::Int
      attribute :dpi,                  type: Types::Coercible::Int,
                                       optional: true
      attribute :language_count,       type: Types::Coercible::Int,
                                       optional: true
      attribute :full_warning_message, type: Types::Strict::String,
                                       optional: true
    end

    # Registers type Types::OcrWarning
    Types.register_type OcrWarning
  end
end
