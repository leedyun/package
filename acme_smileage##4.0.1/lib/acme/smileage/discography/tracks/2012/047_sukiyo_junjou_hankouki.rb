# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class SukiyoJunjouHankouki < Base
          include Singleton

          def initialize
            super
            @name = "好きよ、純情反抗期。"
            @name_romaji = "sukiyo, junjou hankouki."
            @nicknames = ["好き純"]
            @play_time = 288 # 04:48
            @arrangers = ["大久保薫"]
            @hpma = HelloProjectMusicAward.new(2012, 21, 241.5, 132)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-120822-025",
              :utanet => "http://www.uta-net.com/song/134034/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 「好きよ、純情反抗期。」 (MV)",
                :link => "https://www.youtube.com/watch?v=5kPe_AEC3h8",
              },
            ]
            @itunes_links = [
              {
                :title => "好きよ、純情反抗期。",
                :link => "https://itunes.apple.com/jp/album/id549806077",
              },
              {
                :title => "②スマイルセンセーション",
                :link => "https://itunes.apple.com/jp/album/id643254704",
              },
            ]
          end
        end
      end
    end
  end
end
