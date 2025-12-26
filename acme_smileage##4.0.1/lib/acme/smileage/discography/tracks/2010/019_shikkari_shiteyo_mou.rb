# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class ShikkariShiteyoMou < Base
          include Singleton

          def initialize
            super
            @name = "しっかりしてよ！もう"
            @name_romaji = "shikkari shiteyo! mou"
            @nicknames = []
            @play_time = 289 # 04:49
            @arrangers = ["宅見将典"]
            @hpma = HelloProjectMusicAward.new(2011, 95, 10.0, 9)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-101208-049",
              :utanet => "http://www.uta-net.com/song/105944/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "悪ガキッ①",
                :link => "https://itunes.apple.com/jp/album/id403700742",
              },
            ]
          end
        end
      end
    end
  end
end
