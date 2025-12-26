# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class ShinNihonNoSusume < Base
          include Singleton

          def initialize
            super
            @name = "新・日本のすすめ！"
            @name_romaji = "shin nihon no susume!"
            @nicknames = ["親日", "新日本"]
            @play_time = 246 # 04:06
            @arrangers = ["大久保薫"]
            @hpma = HelloProjectMusicAward.new(2013, 13, 614.0, 333)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-130522-189",
              :utanet => "http://www.uta-net.com/song/146548/",
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
