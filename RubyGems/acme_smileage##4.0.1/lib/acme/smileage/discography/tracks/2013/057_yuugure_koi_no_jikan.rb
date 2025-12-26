# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class YuugureKoiNoJikan < Base
          include Singleton

          def initialize
            super
            @name = "夕暮れ 恋の時間"
            @name_romaji = "yuugure koi no jikan"
            @nicknames = ["夕暮れ"]
            @play_time = 291 # 04:51
            @arrangers = ["板垣祐介"]
            @hpma = HelloProjectMusicAward.new(2013, 12, 631.5, 324)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-130522-193",
              :utanet => "http://www.uta-net.com/song/146544/",
            }
            @youtube_links = []
            @itunes_links = [
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
