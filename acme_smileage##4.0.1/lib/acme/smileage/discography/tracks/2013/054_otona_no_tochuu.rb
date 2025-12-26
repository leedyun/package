# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class OtonaNoTochuu < Base
          include Singleton

          def initialize
            super
            @name = "大人の途中"
            @name_romaji = "otona no tochuu"
            @nicknames = []
            @play_time = 240 # 04:00
            @arrangers = ["平田祥一郎"]
            @hpma = HelloProjectMusicAward.new(2013, 26, 270.5, 164)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-130522-190",
              :utanet => "http://www.uta-net.com/song/146547/",
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
