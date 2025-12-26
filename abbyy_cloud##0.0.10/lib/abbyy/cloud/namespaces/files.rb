require_relative "base"

class ABBYY::Cloud
  module Namespaces
    # Namespace for operations with orders
    # @see [https://api.abbyy.cloud/swagger/ui/index#!/File] ABBYY Cloud API
    class Files < Base
      def upload(file, export_format: nil, synthesis_mode: nil, **options)
        options[:exportFormat]  = export_format  if export_format
        options[:synthesisMode] = synthesis_mode if synthesis_mode
        Operations::UploadFile.new(settings).call(file, **options)
      end

      def download(id:, token:)
        Operations::DownloadFile.new(settings).call(id: id, token: token)
      end
    end
  end
end
