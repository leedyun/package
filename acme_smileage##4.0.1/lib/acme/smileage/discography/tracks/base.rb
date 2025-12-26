# -*- encoding: utf-8 -*-

require "date"
require "open-uri"
require "singleton"
require "uri"

require "acme/smileage/discography/hello_project_music_award"
require "acme/smileage/discography/lyrics_downloader"

module Acme
  class Smileage
    class Discography
      module Tracks
        class Base
          DEFAULT_USER_AGENT = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/6.0)"

          attr_reader :name, :name_romaji, :nicknames, :play_time
          attr_reader :lyricists, :composers, :arrangers
          attr_reader :hpma
          attr_reader :lyric_links, :youtube_links, :itunes_links

          def initialize
            @lyricists = ["つんく♂"]
            @composers = ["つんく♂"]
          end

          def cover?; false; end
          def remix?; false; end

          def get_lyrics(site=nil)
            return nil unless self.lyric_links
            Acme::Smileage::Discography::LyricsDownloader.new.get(self.lyric_links, site)
          end
        end
      end
    end
  end
end
