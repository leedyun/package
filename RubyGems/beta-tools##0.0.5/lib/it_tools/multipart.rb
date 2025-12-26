require 'rubygems'
require 'mime/types'
require 'cgi'
require "net/http"
require "uri"

module Multipart
  VERSION = "1.0.0" unless const_defined?(:VERSION)
  
  # Formats a given hash as a multipart form post
  # If a hash value responds to :string or :read messages, then it is
  # interpreted as a file and processed accordingly; otherwise, it is assumed
  # to be a string
  attr_accessor :fp
  class Post
    # We have to pretend like we're a web browser...
    USERAGENT = "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-us) AppleWebKit/523.10.6 (KHTML, like Gecko) Version/3.0.4 Safari/523.10.6" unless const_defined?(:USERAGENT)
    BOUNDARY = "0123456789ABLEWASIEREISAWELBA9876543210" unless const_defined?(:BOUNDARY)
    CONTENT_TYPE = "multipart/form-data; boundary=#{ BOUNDARY }" unless const_defined?(:CONTENT_TYPE)
    HEADER = { "Content-Type" => CONTENT_TYPE, "User-Agent" => USERAGENT } unless const_defined?(:HEADER)
    def initialize
      @fp = []
    end
    def add_file(filename, contents)
      @fp.push(FileParam.new(filename, filename, contents))
    end
    def add_params(params = {})
      params.each do |k, v|
        @fp.push(StringParam.new(k, v))
      end
    end
    def post(url = "http://something.com/uploads")
      uri = URI.parse(url)
      post_body = get_query
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body = post_body.join
      request["Content-Type"] = "multipart/form-data, boundary=#{BOUNDARY}"
      http.request(request)
    end
    def get_query
      query = @fp.collect {|p| "--" + BOUNDARY + "\r\n" + p.to_multipart }.join("")  + "--" + BOUNDARY + "--"
      return query, HEADER
    end
  end
  private
  # Formats a basic string key/value pair for inclusion with a multipart post
  class StringParam
    attr_accessor :k, :v
    def initialize(k, v)
      @k = k
      @v = v
    end
    def to_multipart
      return "Content-Disposition: form-data; name=\"#{CGI::escape(k)}\"\r\n\r\n#{v}\r\n"
    end
  end
  # Formats the contents of a file or string for inclusion with a multipart
  # form post
  class FileParam
    attr_accessor :k, :filename, :content
    def initialize(k, filename, content)
      @k = k
      @filename = filename
      @content = content
    end
    def to_multipart
      # If we can tell the possible mime-type from the filename, use the
      # first in the list; otherwise, use "application/octet-stream"
      mime_type = MIME::Types.type_for(filename)[0] || MIME::Types["application/octet-stream"][0]
      return "Content-Disposition: form-data; name=\"#{CGI::escape(k)}\"; filename=\"#{ filename }\"\r\n" +
        "Content-Type: #{ mime_type.simplified }\r\n\r\n#{ content }\r\n"
    end
  end
end



