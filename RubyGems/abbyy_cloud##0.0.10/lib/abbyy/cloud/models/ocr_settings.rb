require_relative "file_format"
require_relative "ocr_mode"
require_relative "ocr_quality"

class ABBYY::Cloud
  module Models
    class OcrSettings < Model
      attribute :format,  type: Types::FileFormat
      attribute :mode,    type: Types::OcrMode
      attribute :quality, type: Types::OcrQuality
    end

    # Registers type Types::OcrSettings
    Types.register_type OcrSettings
  end
end
