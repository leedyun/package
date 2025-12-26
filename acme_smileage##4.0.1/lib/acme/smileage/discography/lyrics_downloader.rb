# -*- encoding: utf-8 -*-

require "acme/smileage/utils/base_downloader"

module Acme
  class Smileage
    class Discography
      class LyricsDownloader < Acme::Smileage::Utils::BaseDownloader
        def get(lyric_links, site=nil)
          return nil unless lyric_links

          case site
          when :utanet
            get_utanet(lyric_links[:utanet])
          when :utamap
            get_utamap(lyric_links[:utamap])
          when nil
            get(lyric_links, :utanet) or get(lyric_links, :utamap)
          else
            raise ArgumentError, "Invalid site: #{site}"
          end
        end

        private

        def get_utanet(uri)
          return nil if not uri or not uri =~ /\/song\/(\d+)/
          id = $1

          r = http_get(uri, "/user/phplib/swf/showkasi.php?ID=#{id}")
          r = r[(10 + 16 * 4) - 1, r.length - (10 + 16 * 4) - 13]
          r.force_encoding("utf-8")
          r.sub!(/\A\0\n/, "")
          r.strip
        end

        def get_utamap(uri)
          return nil if not uri or not uri =~ /\?surl=([a-zA-Z0-9-]+)/
          id = $1

          r = http_get(uri, "/phpflash/flashfalsephp.php?unum=#{id}")
          r.force_encoding("utf-8")
          r.sub(/^.*?test2=/, "").strip
        end
      end
    end
  end
end
