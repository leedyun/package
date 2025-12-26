
module Cnvrg
  module Downloader
    OLD_SERVER_VERSION_MESSAGE = "Your server version is not relevant for this cli version please contact support for further help."
    MAXIMUM_BACKOFF = 64
    RETRIES = ENV['UPLOAD_FILE_RETRIES'].try(:to_i) || 20
    attr_accessor :bucket, :client
    class Client
      def initialize(params)
        @key = ''
        @iv = ''
        @client = ''
        @bucket = ''
      end

      def extract_key_iv(sts_path)
        count = 0
        begin
          count += 1
          sts_file = open(sts_path, {ssl_verify_mode: 0})
          sts = sts_file.read
          sts.split("\n")
        rescue => e
          backoff_time_seconds = backoff_time(count)
          sleep backoff_time_seconds
          Cnvrg::Logger.log_error(e)
          retry if count <= 20
          raise StandardError.new("Cant access storage: #{e.message}")
        end
      end

      def cut_prefix(prefix, file)
        file.gsub(prefix, '').gsub(/^\/*/, '')
      end

      def download(storage_path, local_path, decrypt: true)
        ### need to be implemented..
      end

      def link_file(cached_commits, local_path, dataset_title, file_name)
        prepare_download(local_path)
        cached_commits.each do |cached_commit|
          nfs_path = "/nfs-disk/#{cached_commit}/#{dataset_title}/#{file_name}"
          if File.exist? nfs_path
            FileUtils.ln(nfs_path, local_path)
            return true
          end
        end
        false
      rescue => e
        Cnvrg::Logger.log_error(e)
        false
      end

      def safe_download(storage_path, local_path, decrypt: true)
        safe_operation(local_path) { self.download(storage_path, local_path, decrypt: decrypt) }
      end

      def upload(storage_path, local_path)
        ### need to be implemented..
      end

      def mkdir(path, recursive: false)
        recursive ? FileUtils.mkdir_p(path) : FileUtils.mkdir(path)
      end

      def prepare_download(local_path)
        mkdir(File.dirname(local_path), recursive: true)
      end

      def decrypt(str)
        Cnvrg::Helpers.decrypt(@key, @iv, str)
      end

      def safe_upload(storage_path, local_path)
        safe_operation(local_path) { self.upload(storage_path, local_path) }
      end

      def self.factory(params)
        params = params.as_json
        case params["storage"]
        when 's3', 'minio'
          return Cnvrg::Downloader::Clients::S3Client.new(sts_path: params["path_sts"], access_key: params["sts_a"], secret: params["sts_s"], session_token: params["sts_st"], region: params["region"], bucket: params["bucket"], encryption: params["encryption"], endpoint: params["endpoint"], storage: params["storage"])
        when 'azure'
          azure_params = params.symbolize_keys.slice(*[:storage_account_name, :storage_access_key, :container, :sts])
          return Cnvrg::Downloader::Clients::AzureClient.new(**azure_params)
        when 'gcp'
          return Cnvrg::Downloader::Clients::GcpClient.new(project_id: params["project_id"], credentials: params["credentials"], bucket_name: params["bucket_name"], sts: params["sts"])
        end
      end

      def safe_operation(local_path)
        n = 1
        error = nil
        while n <= RETRIES
          begin
            yield
            error = nil
            break
          rescue => e
            backoff_time_seconds = backoff_time(n)

            message = "Got error: #{e.class.name} with message: #{e.message} while uploading / downloading a single file: #{local_path}, retry: #{n} of: #{RETRIES}"
            if n < RETRIES
              message += ", next retry in: #{backoff_time_seconds} seconds"
            else
              message += ", done retry, continuing to the next file"
            end
            Cnvrg::Logger.log_error_message(message)

            sleep backoff_time_seconds

            n += 1
            error = e
          end
        end
        raise error if error.present?
        true
      end

      private

      def random_number_milliseconds
        rand(1000) / 1000.0
      end


      def backoff_time(n)
        return [((2**n)+random_number_milliseconds), MAXIMUM_BACKOFF].min
      end

    end
  end
end