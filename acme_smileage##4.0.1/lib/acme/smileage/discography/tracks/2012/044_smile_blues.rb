# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class SmileBlues < Base
          include Singleton

          def initialize
            super
            @name = "すまいるブルース／須磨入姉妹"
            @name_romaji = "smile blues"
            @nicknames = []
            @play_time = 230 # 03:50
            @arrangers = ["高橋諭一"]
            @hpma = HelloProjectMusicAward.new(2012, 131, 5.0, 3)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-120502-082",
              :utanet => "http://www.uta-net.com/song/129101/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "ドットビキニ",
                :link => "https://itunes.apple.com/jp/album/id518280952",
              },
            ]
          end
        end
      end
    end
  end
end
