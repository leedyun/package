# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class Yumemiru15saiPaxJaponicaGrooveRemix < Base
          include Singleton

          def initialize
            super
            @name = "夢見る 15歳 (PAX JAPONICA GROOVE REMIX)"
            @name_romaji = "yumemiru 15sai (pax japonica groove remix)"
            @nicknames = []
            @play_time = 223 # 03:43
            @arrangers = ["平田祥一郎"]
            @hpma = HelloProjectMusicAward.new(2010, 131, 3.0, 2)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-100526-018",
              :utanet => "http://www.uta-net.com/song/95255/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "夢見る 15歳 (PAX JAPONICA GROOVE REMIX)",
                :link => "https://itunes.apple.com/jp/album/id376313178",
              },
            ]
          end

          def remix?; true; end
        end
      end
    end
  end
end
