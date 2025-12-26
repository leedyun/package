# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class JitenshaChiririn < Base
          include Singleton

          def initialize
            super
            @name = "自転車チリリン"
            @name_romaji = "jitensha chiririn"
            @nicknames = ["チリリン"]
            @play_time = 283 # 04:43
            @arrangers = ["藤澤慶昌"]
            @hpma = HelloProjectMusicAward.new(2011, 26, 111.5, 66)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-110810-161",
              :utanet => "http://www.uta-net.com/song/116847/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "有頂天LOVE",
                :link => "https://itunes.apple.com/jp/album/id449821485",
              },
            ]
          end
        end
      end
    end
  end
end
