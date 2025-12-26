require 'rack/utils'

if defined?(Rails)
  require 'acts_as_crafter/railtie'
end

module Rack
  class ActsAsCrafter
    include Rack::Utils

    def initialize(app, opts={})
      @app = app
    end
 
    def call(env)
      status, headers, response = @app.call(env)
      headers = HeaderHash.new(headers)
      if !STATUS_WITH_NO_ENTITY_BODY.include?(status) &&
         !headers['transfer-encoding'] &&
          headers['content-type'] &&
          headers['content-type'].include?("text/html")
         puts "text/html!"
         response.body = transform(response.body)
      end
      
      [status, headers, response]
    end
    
    protected
    
    # Yup, this is ugly as hell, but I'm drinking Cîroc vodka out of a plastic cup at Rails Camp 8 in Perth.
    def transform(body)
      body.gsub(/<p(.*?)>(.*?)<\/p>/) { |s| 
        "<p#{$1}>Mate, #{($2[0..0] == "I" ? "I" : $2[0..0].downcase) + $2[1..-1].gsub(/\.$/, '')}, mate.</p>"
      }.gsub(/<li>(.*?)<\/li>/) { |s| 
        "<li>Mate, #{($1[0..0] == "I" ? "I" : $1[0..0].downcase) + $1[1..-1].gsub(/\.$/, '')}, mate.</li>"
      }.gsub(/<h1>(.*?)<\/h1>/) { |s| 
        "<h1>#{$1[0..-1].gsub(/\.$/, '')}, Mate!</h1>"
      }.gsub(/<h2>(.*?)<\/h2>/) { |s|      
        "<h2>#{$1[0..-1].gsub(/\.$/, '')}, Mate!</h2>"
      }.gsub(/<h3>(.*?)<\/h3>/) { |s|      
        "<h3>#{$1[0..-1].gsub(/\.$/, '')}, Mate!</h3>"
      }.gsub(/\bwater\b/, "Cîroc")
    end
    
  end
end