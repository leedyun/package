require 'rubygems'
gem 'aws-s3'
require 'aws/s3'

class AssetUploader
  class Uploader
    
    def self.get_env(name)
      ENV[name] || begin
        STDERR.puts "#{name} is not set in your environment"
        exit(1)
      end
    end

    S3_CONFIG = {
      :access_key_id     => get_env('AU_ACCESS_KEY_ID'),
      :secret_access_key => get_env('SECRET_ACCESS_KEY'),
      :bucket_name       => get_env('AU_BUCKET_NAME')
    }

    def do_upload(name, filename)
      content = open(filename)
      connect_to_s3  
      bucket = S3_CONFIG[:bucket_name]
      ext = File.extname(filename)
      AWS::S3::S3Object.store(name, 
                              content, 
                              bucket, 
                              :access => :public_read)
#                              :content_type => MIME_TYPES[ext], 
#                              :content_disposition => 'attachment')
      AWS::S3::S3Object.url_for(name, bucket)
    end
    
  private

    def connect_to_s3
      self.class.connect_to_s3
    end

    def self.connect_to_s3
      AWS::S3::Base.establish_connection!(
        :access_key_id     => S3_CONFIG[:access_key_id],
        :secret_access_key => S3_CONFIG[:secret_access_key]
      )
    end

  end
end