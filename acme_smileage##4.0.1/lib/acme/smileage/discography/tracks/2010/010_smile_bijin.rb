# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class SmileBijin < Base
          include Singleton

          def initialize
            super
            @name = "スマイル美人"
            @name_romaji = "smile bijin"
            @nicknames = []
            @play_time = 242 # 04:02
            @arrangers = ["平田祥一郎"]
            @hpma = HelloProjectMusicAward.new(2010, 57, 30.5, 18)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-100728-118",
              :utanet => "http://www.uta-net.com/song/98769/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "○○ がんばらなくてもええねんで！！",
                :link => "https://itunes.apple.com/jp/album/id382386730",
              },
            ]
          end
        end
      end
    end
  end
end
