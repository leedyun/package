# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class Samuine < Base
          include Singleton

          def initialize
            super
            @name = "寒いね。"
            @name_romaji = "samuine."
            @nicknames = []
            @play_time = 283 # 04:43
            @arrangers = ["大久保薫"]
            @hpma = HelloProjectMusicAward.new(2012, 16, 328.5, 202)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-121128-150",
              :utanet => "http://www.uta-net.com/song/138712/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 「寒いね。」 (MV)",
                :link => "https://www.youtube.com/watch?v=ZxFhVH2tNzc",
              },
              {
                :title => "スマイレージ 「寒いね。」 (Live Ver.)",
                :link => "https://www.youtube.com/watch?v=VDFAXMSSt2o",
              },
            ]
            @itunes_links = [
              {
                :title => "寒いね。",
                :link => "https://itunes.apple.com/jp/album/id576697867",
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
