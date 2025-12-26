# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class Eeka < Base
          include Singleton

          def initialize
            super
            @name = "ええか！？"
            @name_romaji = "eeka!?"
            @nicknames = []
            @play_time = 233 # 03:53
            @arrangers = ["近藤圭一"]
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-131218-069",
              :utanet => "http://www.uta-net.com/song/157051/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 『ええか！？』 (S/mileage[Do you get it?]) (MV)",
                :link => "https://www.youtube.com/watch?v=Iv0IW0tVzjc",
              },
              {
                :title => "スマイレージ 『ええか！？』 (S/mileage[Do you get it?]) (Dance Shot Ver.)",
                :link => "https://www.youtube.com/watch?v=OLGcS_ngf7s",
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
