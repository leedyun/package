# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class NamidaGirl < Base
          include Singleton

          def initialize
            super
            @name = "涙 GIRL"
            @name_romaji = "namida girl"
            @nicknames = []
            @play_time = 224 # 03:44
            @arrangers = ["板垣祐介"]
            @hpma = HelloProjectMusicAward.new(2012, 108, 10.5, 8)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-120201-014",
              :utanet => "http://www.uta-net.com/song/125053/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "チョトマテクダサイ！",
                :link => "https://itunes.apple.com/jp/album/id496149549",
              },
            ]
          end

          def cover?; true; end
        end
      end
    end
  end
end
