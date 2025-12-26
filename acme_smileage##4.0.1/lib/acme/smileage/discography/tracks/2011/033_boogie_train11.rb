# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class BoogieTrain11 < Base
          include Singleton

          def initialize
            super
            @name = "ブギートレイン'11"
            @name_romaji = "boogie train'11"
            @nicknames = ["ブギトレ"]
            @play_time = 280 # 04:40
            @arrangers = ["大久保薫"]
            @hpma = HelloProjectMusicAward.new(2011, 142, 2.0, 2)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-110928-018",
              :utanet => "http://www.uta-net.com/song/140548/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "タチアガール",
                :link => "https://itunes.apple.com/jp/album/id464722704",
              },
            ]
          end

          def cover?; true; end
        end
      end
    end
  end
end
