module AssetLink
  class Config

    # FOG configuration
    attr_accessor :fog_provider, :fog_directory, :fog_region

    # Amazon AWS
    attr_accessor :aws_access_key_id, :aws_secret_access_key

    def initialize
      self.fog_provider = ENV.fetch('FOG_PROVIDER') { 'AWS' }
      self.fog_directory = ENV['FOG_DIRECTORY'] || ENV['AWS_S3_BUCKET']
      self.fog_region = ENV['FOG_REGION'] || ENV['AWS_REGION']
      self.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
      self.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    end

    def fog_options
      options = {
          provider: fog_provider,
          aws_access_key_id: aws_access_key_id,
          aws_secret_access_key: aws_secret_access_key
      }
      options.merge!({region: fog_region}) if fog_region
      options
    end

  end
end
