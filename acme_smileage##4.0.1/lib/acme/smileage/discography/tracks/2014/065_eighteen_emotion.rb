# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class EighteenEmotion < Base
          include Singleton

          def initialize
            super
            @name = "エイティーン エモーション"
            @name_romaji = "eighteen emotion"
            @nicknames = ["エイエモ", "18エモ"]
            @play_time = 217 # 3:37
            @arrangers = ["板垣祐介"]
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-140430-016",
              :utanet => "http://www.uta-net.com/song/163164/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ『エイティーン エモーション』 (S/mileage[Eighteen Emotion]) (Promotion edit)",
                :link => "https://www.youtube.com/watch?v=fAPI8PW2q-A",
              },
              {
                :title => "スマイレージ 『エイティーン エモーション』 (S/mileage[Eighteen Emotion]) (Dance Shot Ver.)",
                :link => "https://www.youtube.com/watch?v=nwZe4wpgc_U",
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
