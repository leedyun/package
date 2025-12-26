# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class SmileageSinglesGekiyabaRemix < Base
          include Singleton

          def initialize
            super
            @name = "スマイレージ シングルス 激ヤバリミックス"
            @name_romaji = "smileage singles gekiyaba remix"
            @nicknames = []
            @play_time = 251 # 04:11
            @arrangers = ["渡辺泰司"]
            @hpma = HelloProjectMusicAward.new(2012, 155, 1.5, 3)
            @lyric_links = {}
            @youtube_links = []
            @itunes_links = [
              {
                :title => "プリーズ ミニスカ ポストウーマン！",
                :link => "https://itunes.apple.com/jp/album/id487508467",
              },
            ]
          end

          def remix?; true; end
        end
      end
    end
  end
end
