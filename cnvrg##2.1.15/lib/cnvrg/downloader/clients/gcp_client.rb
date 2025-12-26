require "google/cloud/storage"

module Cnvrg
  module Downloader
    module Clients
      class GcpClient < Client
        def initialize(project_id: nil, credentials: nil, bucket_name: nil, sts: nil)
          @key, @iv = extract_key_iv(sts)
          @project_id = Cnvrg::Helpers.decrypt(@key, @iv, project_id) if project_id.present?
          @credentials_path = Cnvrg::Helpers.decrypt(@key, @iv, credentials)
          @tempfile = nil
          @bucket_name = Cnvrg::Helpers.decrypt(@key, @iv, bucket_name)
          init_gcp_credentials
          @storage = Google::Cloud::Storage.new(project_id: @project_id, credentials: @credentials, retries: 50, timeout: 43200)
          @bucket = @storage.bucket(@bucket_name)
          @bucket.name
        rescue => e
          Cnvrg::Logger.log_error(e)
          Cnvrg::Logger.log_info("Tried to init gcp client without success.")
          Cnvrg::CLI.log_message("Cannot init client. please contact support to check your bucket credentials.")
          exit(1)
        end

        def init_gcp_credentials
          t = Tempfile.new
          f = open(@credentials_path).read
          t.binmode
          t.write(f)
          t.rewind
          @credentials = t.path
          @tempfile = t
        end

        def download(storage_path, local_path, decrypt: true)
          prepare_download(local_path)
          file = @bucket.file(decrypt(storage_path))
          file.download local_path
        end

        def upload(storage_path, local_path)
          begin
            @bucket.create_file(local_path, storage_path)
          rescue => e
            raise e
          end
        end
      end
    end
  end
end
