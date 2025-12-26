# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class Odorouyo < Base
          include Singleton

          def initialize
            super
            @name = "踊ろうよ"
            @name_romaji = "odorouyo"
            @nicknames = []
            @play_time = 274 # 04:34
            @arrangers = ["藤澤慶昌"]
            @hpma = HelloProjectMusicAward.new(2011, 121, 4.5, 2)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-101208-046",
              :utanet => "http://www.uta-net.com/song/105949/",
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
