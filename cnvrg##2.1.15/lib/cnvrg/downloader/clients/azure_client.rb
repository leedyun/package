require 'open-uri'
require 'azure/storage/blob'
require 'azure/storage/common/core'

module Cnvrg
  module Downloader
    module Clients
      class AzureClient < Client
        def initialize(storage_account_name: nil, storage_access_key: nil, container: nil, sts: nil)
          @key, @iv = extract_key_iv(sts)
          @account_name = Cnvrg::Helpers.decrypt(@key, @iv, storage_account_name)
          @access_key = Cnvrg::Helpers.decrypt(@key, @iv, storage_access_key)
          @container = Cnvrg::Helpers.decrypt(@key, @iv, container)
        end

        def download(storage_path, local_path, decrypt: true)
          prepare_download(local_path)
          storage_path = Cnvrg::Helpers.decrypt(@key, @iv, storage_path) if decrypt

          # We generate a temp uri in order to stream the file instead of using "get_blob" that overflows memory
          uri = client.send(:blob_uri, @container, storage_path)


          expiring_url = self.signed_uri_custom(
            uri,
            false,
            service: 'b',
            resource: 'b',
            permissions: 'r',
            start: (Time.now - (5 * 60)).utc.iso8601, # start 5 minutes ago
            expiry: (Time.now + 60 * 60 * 2).utc.iso8601 # expire in 2 hours
          )
          # Stream the file without loading it all into memory
          download = open(expiring_url)
          IO.copy_stream(download, local_path)
        end

        def signed_uri_custom(uri, use_account_sas, options)
          # url sent to generate_service_sas_token should be DECODED (file names with spaces should not be encoded with %20)
          url = URI.decode(uri.path)
          generator = Azure::Storage::Common::Core::Auth::SharedAccessSignature.new(@account_name, @access_key)

          CGI::parse(uri.query || "").inject({}) { |memo, (k, v)| memo[k.to_sym] = v; memo }

          if options[:service] == (nil) && uri.host != (nil)
            host_splits = uri.host.split(".")
            options[:service] = host_splits[1].chr if host_splits.length > 1 && host_splits[0] == @account_name
          end

          sas_params = if use_account_sas
                         generator.generate_account_sas_token(options)
                       else
                         generator.generate_service_sas_token(url, options)
                       end

          URI.parse(uri.to_s + (uri.query.nil? ? "?" : "&") + sas_params)
        end

        def upload(storage_path, local_path)
          begin
            client.create_block_blob(@container, storage_path, File.open(local_path, "rb"))
          rescue => e
            raise e
          end
        end

        def fetch_files(prefix: nil, marker: nil, limit: 10000)
          blobs = client.list_blobs(@container, prefix: prefix, max_results: limit, marker: marker)
          next_marker = blobs.continuation_token
          files = blobs.map{|x| x.name}
          [files, next_marker]
        end


        private
        def client
          Azure::Storage::Blob::BlobService.create(storage_account_name: @account_name, storage_access_key: @access_key)
        end
      end
    end
  end
end