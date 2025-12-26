# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class GakkyuuIinchou < Base
          include Singleton

          def initialize
            super
            @name = "学級委員長"
            @name_romaji = "gakkyuu iinchou"
            @nicknames = []
            @play_time = 258 # 04:18
            @arrangers = ["鈴木Daichi秀行"]
            @hpma = HelloProjectMusicAward.new(2011, 85, 12.0, 6)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-101208-048",
              :utanet => "http://www.uta-net.com/song/105945/",
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
