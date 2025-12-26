# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class KoibitoHaKokoroNoOuendan < Base
          include Singleton

          def initialize
            super
            @name = "恋人は心の応援団"
            @name_romaji = "koibito ha kokoro no ouendan"
            @nicknames = []
            @play_time = 250 # 04:10
            @arrangers = ["板垣祐介"]
            @hpma = HelloProjectMusicAward.new(2012, 98, 14.0, 12)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-120502-083",
              :utanet => "http://www.uta-net.com/song/129100/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "ドットビキニ",
                :link => "https://itunes.apple.com/jp/album/id518280736",
              },
            ]
          end

          def cover?; true; end
        end
      end
    end
  end
end
