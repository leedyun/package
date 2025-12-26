# -*- encoding: utf-8 -*-

require "open-uri"
require "uri"

require "nokogiri"

module Acme
  class Smileage
    module Utils
      class BaseDownloader
        DEFAULT_USER_AGENT = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)"

        private

        def with_nokogiri(baseuri, path = nil)
          uri = make_uri(baseuri, path)
          open(uri, "User-Agent" => DEFAULT_USER_AGENT) do |f|
            yield Nokogiri::HTML(f), uri
          end
        end

        def http_get(baseuri, path = nil)
          open(make_uri(baseuri, path), "User-Agent" => DEFAULT_USER_AGENT) {|f| f.read }
        end

        def make_uri(baseuri, path = nil)
          r = URI(baseuri)
          if path
            r + path
          else
            r
          end
        end
      end
    end
  end
end
