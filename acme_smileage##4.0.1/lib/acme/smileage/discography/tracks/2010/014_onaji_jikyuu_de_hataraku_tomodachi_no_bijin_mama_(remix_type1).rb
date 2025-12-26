# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class OnajiJikyuuDeHatarakuTomodachiNoBijinMamaRemixType1 < Base
          include Singleton

          def initialize
            super
            @name = "同じ時給で働く友達の美人ママ (Remix Type1)"
            @name_romaji = "onaji jikyuu de hataraku tomodachi no bijin mama (remix type1)"
            @nicknames = []
            @play_time = 249 # 04:09
            @arrangers = ["山崎淳"]
            @hpma = HelloProjectMusicAward.new(2010, 143, 2.0, 1)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-100929-010",
              :utanet => "http://www.uta-net.com/song/102019/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "同じ時給で働く友達の美人ママ (Remix Type1)",
                :link => "https://itunes.apple.com/jp/album/id401615685",
              },
            ]
          end

          def remix?; true; end
        end
      end
    end
  end
end
