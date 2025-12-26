# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class Iiyatsu < Base
          include Singleton

          def initialize
            super
            @name = "「良い奴」"
            @name_romaji = "iiyatsu"
            @nicknames = []
            @play_time = 279 # 04:39
            @arrangers = ["大久保薫"]
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-131218-070",
              :utanet => "http://www.uta-net.com/song/157050/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 『「良い奴」』(S/mileage[Nice Guy]) (MV)",
                :link => "https://www.youtube.com/watch?v=o3yVG8y6oIc",
              },
              {
                :title => "スマイレージ 『「良い奴」』(S/mileage[Nice Guy]) (Dance Shot Ver.)",
                :link => "https://www.youtube.com/watch?v=xlD51e__7Pw",
              },
            ]
            @itunes_links = [
              {
                :title => "ええか！？／「良い奴」",
                :link => "https://itunes.apple.com/jp/album/id772780890",
              },
            ]
          end
        end
      end
    end
  end
end
