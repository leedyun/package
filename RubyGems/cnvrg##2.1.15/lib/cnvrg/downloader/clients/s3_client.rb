module Cnvrg
  module Downloader
    module Clients
      class S3Client < Client
        def initialize(sts_path: nil, access_key: nil, secret: nil, session_token: nil, region: nil, bucket: nil, encryption: nil, endpoint: nil, storage: nil)
          @key, @iv = extract_key_iv(sts_path)
          @access_key = Cnvrg::Helpers.decrypt(@key, @iv, access_key)
          @secret = Cnvrg::Helpers.decrypt(@key, @iv, secret)
          @session_token = Cnvrg::Helpers.decrypt(@key, @iv, session_token)
          @region = Cnvrg::Helpers.decrypt(@key, @iv, region)
          @bucket_name = Cnvrg::Helpers.decrypt(@key, @iv, bucket)
          @endpoint = Cnvrg::Helpers.decrypt(@key, @iv, endpoint)
          options = {
              :access_key_id => @access_key,
              :secret_access_key => @secret,
              :session_token => @session_token,
              :region => @region,
              :http_open_timeout => 60, :retry_limit => 20
          }
          if storage == 'minio'
            options.delete(:session_token)
            options = options.merge({
                                        :force_path_style => true,
                                        :ssl_verify_peer => false,
                                        :endpoint => @endpoint,
                                    })
          end

          @options = options

          #@client = Aws::S3::Client.new(options)
          #@bucket = Aws::S3::Resource.new(client: @client).bucket(@bucket_name)
          @upload_options = {:use_accelerate_endpoint => storage == 's3'}
          if encryption.present?
            @upload_options[:server_side_encryption] = encryption
          end
        end

        def download(storage_path, local_path, decrypt: true)
          prepare_download(local_path)
          storage_path = Cnvrg::Helpers.decrypt(@key, @iv, storage_path) if decrypt
          resp = nil
          File.open(local_path, 'w+') do |file|
            resp = aws_client.get_object({bucket: @bucket_name, key: storage_path}, target: file)
          end
          resp
        rescue => e
          Cnvrg::Logger.log_error(e)
          raise e
        end

        def upload(storage_path, local_path)
          ### storage path is the path inside s3 (after the bucket)
          # local path is fullpath for the file /home/ubuntu/user.../hazilim.py
          o = aws_bucket.object(storage_path)
          success = o.upload_file(local_path, @upload_options)
          return success
        rescue => e
          raise e
        end

        def fetch_files(prefix: nil, marker: nil, limit: 1000)
          batch_files = aws_bucket.objects(prefix: prefix, marker: marker).first(limit)
          batch_files.to_a.map(&:key)
        end

        private
        def aws_client
          Aws::S3::Client.new(@options)
        end

        def aws_bucket
          Aws::S3::Resource.new(client: aws_client).bucket(@bucket_name)
        end
      end
    end
  end
end