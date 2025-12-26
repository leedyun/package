require_relative "file_reference"
require_relative "locale"
require_relative "ocr_settings"
require_relative "ocr_statistics"
require_relative "ocr_warning"
require_relative "reading_status"
require_relative "text_statistics"

class ABBYY::Cloud
  module Models
    class FileInfo < FileReference
      attribute :name,             type: Types::Strict::String
      attribute :mime,             type: Types::Strict::String
      attribute :created,          type: Types::Form::Time
      attribute :is_recognizable,  type: Types::Form::Bool
      attribute :is_deleted,       type: Types::Form::Bool
      attribute :reading_status,   type: Types::Strict::String
      attribute :reading_progress, type: Types::Coercible::Int
      attribute :processed,        type: Types::Form::Time,     optional: true
      attribute :deleted,          type: Types::Form::Time,     optional: true
      attribute :error,            type: Types::Strict::String, optional: true
      attribute :statistics,       type: Types::TextStatistics, optional: true
      attribute :ocr_settings,     type: Types::OcrSettings,    optional: true
      attribute :ocr_statistics,   type: Types::OcrStatistics,  optional: true
      attribute :expected_languages,
                type: Types::Array.member(Types::Locale),
                optional: true
      attribute :ocr_warnings,
                type: Types::Array.member(Types::OcrWarning),
                optional: true
    end

    # Registers type Types::FileInfo
    Types.register_type FileInfo
  end
end
