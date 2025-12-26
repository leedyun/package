# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class ChanceTourai < Base
          include Singleton

          def initialize
            super
            @name = "チャンス到来！"
            @name_romaji = "chance tourai"
            @nicknames = []
            @play_time = 231 # 03:51
            @arrangers = ["板垣祐介"]
            @hpma = HelloProjectMusicAward.new(2012, 84, 19.5, 15)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-120201-013",
              :utanet => "http://www.uta-net.com/song/126048/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "チョトマテクダサイ！",
                :link => "https://itunes.apple.com/jp/album/id496149565",
              },
            ]
          end
        end
      end
    end
  end
end
