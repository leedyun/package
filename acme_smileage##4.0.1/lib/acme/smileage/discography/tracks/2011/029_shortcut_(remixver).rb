# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class ShortcutRemixver < Base
          include Singleton

          def initialize
            super
            @name = "ショートカット (Remix.Ver)"
            @name_romaji = "shortcut (remix.ver)"
            @nicknames = []
            @play_time = 268 # 04:28
            @arrangers = ["平田祥一郎"]
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-110209-011",
              :utanet => "http://www.uta-net.com/song/108524/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "ショートカット (Remix.Ver)",
                :link => "https://itunes.apple.com/jp/album/id457769698",
              },
            ]
          end

          def remix?; true; end
        end
      end
    end
  end
end
