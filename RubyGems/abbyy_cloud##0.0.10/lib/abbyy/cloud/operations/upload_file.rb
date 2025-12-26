require_relative "base"

class ABBYY::Cloud
  module Operations
    class UploadFile < Base
      link "https://api.abbyy.cloud/swagger/ui/index#!/File/File_UploadFile"
      path { "v0/file" }
      http_method "post"

      request_type :file

      request_query do
        attribute :quality,       type: Types::OcrQuality, optional: true
        attribute :synthesisMode, type: Types::OcrMode,    optional: true
        attribute :exportFormat,  type: Types::FileFormat, optional: true
        attribute :languages,     type: Types::Array.member(Types::Locale),
                                  optional: true
      end

      response_body Types::Array.member(Types::FileInfo)
    end
  end
end
