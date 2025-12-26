# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class HatukoiNoAnatahe < Base
          include Singleton

          def initialize
            super
            @name = "初恋の貴方へ"
            @name_romaji = "hatukoi no anatahe"
            @nicknames = []
            @play_time = 263 # 04:23
            @arrangers = ["板垣祐介"]
            @hpma = HelloProjectMusicAward.new(2011, 72, 18.5, 10)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-110427-199",
              :utanet => "http://www.uta-net.com/song/140550/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "恋にBooing ブー！",
                :link => "https://itunes.apple.com/jp/album/id429866286",
              },
            ]
          end
        end
      end
    end
  end
end
