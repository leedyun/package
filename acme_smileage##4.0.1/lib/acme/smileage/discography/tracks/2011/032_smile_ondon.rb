# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class SmileOndon < Base
          include Singleton

          def initialize
            super
            @name = "スマイル音丼"
            @name_romaji = "smile ondon"
            @nicknames = []
            @play_time = 218 # 03:38
            @arrangers = ["オオバコウスケ"]
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-110928-017",
              :utanet => "http://www.uta-net.com/song/119199/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "タチアガール",
                :link => "https://itunes.apple.com/jp/album/id464722574",
              },
            ]
          end
        end
      end
    end
  end
end
