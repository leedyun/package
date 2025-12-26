# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class Doushiyou < Base
          include Singleton

          def initialize
            super
            @name = "どうしよう"
            @name_romaji = "doushiyou"
            @nicknames = []
            @play_time = 232 # 03:52
            @arrangers = ["平田祥一郎"]
            @hpma = HelloProjectMusicAward.new(2013, 88, 32.0, 18)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-130320-047",
              :utanet => "http://www.uta-net.com/song/143841/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "旅立ちの春が来た",
                :link => "https://itunes.apple.com/jp/album/id611090467",
              },
            ]
          end
        end
      end
    end
  end
end
