# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class TewoNigitteArukitai < Base
          include Singleton

          def initialize
            super
            @name = "手を握って歩きたい"
            @name_romaji = "tewo nigitte arukitai"
            @nicknames = []
            @play_time = 266 # 04:26
            @arrangers = ["大久保薫"]
            @hpma = HelloProjectMusicAward.new(2012, 140, 3.0, 4)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-111228-033",
              :utanet => "http://www.uta-net.com/song/123903/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "プリーズ ミニスカ ポストウーマン！",
                :link => "https://itunes.apple.com/jp/album/id487505638",
              },
            ]
          end

          def cover?; true; end
        end
      end
    end
  end
end
