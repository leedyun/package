# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class MysteryNight < Base
          include Singleton

          def initialize
            super
            @name = "ミステリーナイト！"
            @name_romaji = "mystery night!"
            @nicknames = ["ミスナイ"]
            @play_time = 264 # 4:24
            @arrangers = ["平田祥一郎"]
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-140430-015",
              :utanet => "http://www.uta-net.com/song/163165/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 『ミステリーナイト！』 (S/mileage[A Mistery Night!]) (Promotion edit)",
                :link => "https://www.youtube.com/watch?v=gh6-f1EV_14",
              },
              {
                :title => "スマイレージ 『ミステリーナイト！』 (S/mileage[A Mistery Night!]) (Dance Shot Ver.)",
                :link => "https://www.youtube.com/watch?v=bpykoK1eWsg",
              },
            ]
            @itunes_links = [
              {
                :title => "ミステリーナイト!/エイティーン エモーション",
                :link => "https://itunes.apple.com/jp/album/id859045562",
              },
            ]
          end
        end
      end
    end
  end
end
