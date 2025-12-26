# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class KimiHaJitenshaWatasiHaDensyaDeKitaku < Base
          include Singleton

          def initialize
            super
            @name = "君は自転車 私は電車で帰宅"
            @name_romaji = "kimi ha jitensha watasi ha densya de kitaku"
            @nicknames = ["君チャリ"]
            @play_time = 295 # 04:55
            @arrangers = ["山崎淳"]
            @hpma = HelloProjectMusicAward.new(2012, 100, 13.0, 11)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-120822-026",
              :utanet => "http://www.uta-net.com/song/134033/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "好きよ、純情反抗期。",
                :link => "https://itunes.apple.com/jp/album/id549806077",
              },
            ]
          end

          def cover?; true; end
        end
      end
    end
  end
end
