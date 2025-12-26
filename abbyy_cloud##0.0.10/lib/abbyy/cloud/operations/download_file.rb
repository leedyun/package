require_relative "base"

class ABBYY::Cloud
  module Operations
    class DownloadFile < Base
      link "https://api.abbyy.cloud/swagger/ui/index#!/File/File_DownloadFile"
      path { "v0/file/#{id}/#{token}" }
      http_method "get"
      response_type :file
    end
  end
end
