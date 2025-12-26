module ArchiveUploader
  class Curb
    def initialize(options={})
      @options = options
      @curl = Curl::Easy.new(@options[:url])
      check_for_auth
    end
    
    def perform!
      @curl.multipart_form_post = true
      @curl.http_post(*post_data)
    end

    def check_for_auth
      return unless @options[:auth]
      if @options[:auth]._method == :basic
        @curl.http_auth_types = :basic
        @curl.username = @options[:auth].user
        @curl.password = @options[:auth].password
      end
    end
    
    def post_data
      fields = @options[:fields].collect do |field, value|
        Curl::PostField.content("file[#{field}]", value)
      end
      [Curl::PostField.file('file[file]', @options[:file])] + fields
    end
  end
end
