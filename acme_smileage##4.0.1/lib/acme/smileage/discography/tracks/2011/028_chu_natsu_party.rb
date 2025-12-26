# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class ChuNatsuParty < Base
          include Singleton

          def initialize
            super
            @name = "チュッ！夏パ～ティ"
            @name_romaji = "chu natsu party"
            @nicknames = ["夏パ"]
            @play_time = 234 # 03:54
            @arrangers = ["大久保薫"]
            @hpma = HelloProjectMusicAward.new(2011, 137, 2.5, 2)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-110810-162",
              :utanet => "http://www.uta-net.com/song/116846/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "有頂天LOVE",
                :link => "https://itunes.apple.com/jp/album/id449821345",
              },
            ]
          end

          def cover?; true; end
        end
      end
    end
  end
end
