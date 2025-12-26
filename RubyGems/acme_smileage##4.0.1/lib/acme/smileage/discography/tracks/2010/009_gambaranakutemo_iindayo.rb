# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class GambaranakutemoIindayo < Base
          include Singleton

          def initialize
            super
            @name = "○○ がんばらなくてもいいんだよ！！"
            @name_romaji = "gambaranakutemo iindayo"
            @nicknames = []
            @play_time = 255 # 04:15
            @arrangers = ["高橋諭一"]
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-100728-117",
              :utanet => "http://www.uta-net.com/song/98770/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 「○○ がんばらなくてもいいんだよ！！」 (MV)",
                :link => "https://www.youtube.com/watch?v=FAHiyJj_1w4",
              },
              {
                :title => "スマイレージ 「○○ がんばらなくてもいいんだよ！！」 (Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=QtWKqgKE-jU",
              },
            ]
            @itunes_links = [
              {
                :title => "○○ がんばらなくてもええねんで！！",
                :link => "https://itunes.apple.com/jp/album/id382386730",
              },
            ]
          end
        end
      end
    end
  end
end
