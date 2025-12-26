# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class KiiroiJitenshaToSandwich < Base
          include Singleton

          def initialize
            super
            @name = "黄色い自転車とサンドウィッチ"
            @name_romaji = "kiiroi jitensha to sandwich"
            @nicknames = ["黄色い自転車"]
            @play_time = 233 # 03:53
            @arrangers = ["オオバコウスケ"]
            @hpma = HelloProjectMusicAward.new(2012, 32, 123.0, 69)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-120530-121",
              :utanet => "http://www.uta-net.com/song/131208/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "スマイレージ ベストアルバム完全版①",
                :link => "https://itunes.apple.com/jp/album/id528168545",
              },
            ]
          end
        end
      end
    end
  end
end
