# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class WatashiChoitoKawaiiUrabancho < Base
          include Singleton

          def initialize
            super
            @name = "私、ちょいとかわいい裏番長"
            @name_romaji = "watashi choito kawaii urabancho"
            @nicknames = ["ちょいかわ", "ちょいかわ番長", "裏番長"]
            @play_time = 254 # 04:14
            @arrangers = ["板垣祐介"]
            @hpma = HelloProjectMusicAward.new(2012, 20, 253.5, 113)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-121128-151",
              :utanet => "http://www.uta-net.com/song/138711/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "寒いね。",
                :link => "https://itunes.apple.com/jp/album/id576697867",
              },
            ]
          end
        end
      end
    end
  end
end
