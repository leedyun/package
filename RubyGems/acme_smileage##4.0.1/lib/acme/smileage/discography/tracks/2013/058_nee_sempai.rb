# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class NeeSempai < Base
          include Singleton

          def initialize
            super
            @name = "ねぇ 先輩"
            @name_romaji = "nee sempai"
            @nicknames = []
            @play_time = 290 # 04:50
            @arrangers = ["平田祥一郎"]
            @hpma = HelloProjectMusicAward.new(2013, 62, 93.0, 62)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-130522-194",
              :utanet => "http://www.uta-net.com/song/146543/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "②スマイルセンセーション",
                :link => "https://itunes.apple.com/jp/album/id643254704",
              },
            ]
          end
        end
      end
    end
  end
end
