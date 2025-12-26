# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class PanyasanNoArbeit < Base
          include Singleton

          def initialize
            super
            @name = "パン屋さんのアルバイト"
            @name_romaji = "panyasan no arbeit"
            @nicknames = ["パン屋"]
            @play_time = 264 # 04:24
            @arrangers = ["鈴木俊介"]
            @hpma = HelloProjectMusicAward.new(2011, 13, 229.5, 95)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-110209-012",
              :utanet => "http://www.uta-net.com/song/140549/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "ショートカット",
                :link => "https://itunes.apple.com/jp/album/id417219096",
              },
            ]
          end
        end
      end
    end
  end
end
