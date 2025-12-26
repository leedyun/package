# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class TabidachiNoHaruGaKita < Base
          include Singleton

          def initialize
            super
            @name = "旅立ちの春が来た"
            @name_romaji = "tabidachi no haru ga kita"
            @nicknames = ["旅春"]
            @play_time = 292 # 04:52
            @arrangers = ["大久保薫"]
            @hpma = HelloProjectMusicAward.new(2013, 27, 266.0, 174)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-130320-046",
              :utanet => "http://www.uta-net.com/song/143842/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 「旅立ちの春が来た」 (MV)",
                :link => "https://www.youtube.com/watch?v=Xe1IOiDlwtc",
              },
            ]
            @itunes_links = [
              {
                :title => "旅立ちの春が来た",
                :link => "https://itunes.apple.com/jp/album/id611090467",
              },
              {
                :title => "②スマイルセンセーション",
                :link => "https://itunes.apple.com/jp/album/id643254704",
              },
            ]
          end
        end
      end
    end
  end
end
