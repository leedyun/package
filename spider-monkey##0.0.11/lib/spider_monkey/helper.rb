module SpiderMonkey
  module Helper
    def resized_image_url(options)
      options = options.reverse_merge(
        key: SpiderMonkey.configuration[:user_key]
      )
      validation = SpiderMonkey::Validator.new(options).validate_options
      if validation[:passed] || validation[:recoverable]
        options = validation[:valid_options]
        
        options_string = spider_monkey_string_from_options_hash(options)
        signature = spider_monkey_signature_from_options_string(options_string)
    
        compressed_string = Base64.urlsafe_encode64(Zlib::Deflate.deflate(options_string))
    
        "#{SpiderMonkey.configuration[:protocol]}://#{SpiderMonkey.configuration[:cloudfront_host]}/c?o=#{compressed_string}&s=#{signature}"
      else
        ""
      end
    end
    
    def async_resized_image_url(options, priority = "medium")
      priority = "medium" unless ["low", "medium", "high"].include?(priority)
      resized_image_url(options).gsub(SpiderMonkey.configuration[:cloudfront_host], "usespidermonkey.com/api/v1/u/#{SpiderMonkey.configuration[:user_key]}") + "&priority=#{priority}"
    end
  
    private
    def spider_monkey_string_from_options_hash(options)
      json_string = options.to_json
    end
  
    def spider_monkey_signature_from_options_string(options_string)
      secret = SpiderMonkey.configuration[:user_secret]
      OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), secret, options_string)
    end
  end
end