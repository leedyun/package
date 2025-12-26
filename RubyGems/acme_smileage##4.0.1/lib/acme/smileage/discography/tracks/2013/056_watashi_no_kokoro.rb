# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class WatashiNoKokoro < Base
          include Singleton

          def initialize
            super
            @name = "私の心"
            @name_romaji = "watashi no kokoro"
            @nicknames = []
            @play_time = 293 # 04:53
            @arrangers = ["大久保薫"]
            @hpma = HelloProjectMusicAward.new(2013, 48, 161.0, 100)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-130522-192",
              :utanet => "http://www.uta-net.com/song/146545/",
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
