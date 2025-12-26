# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class Dotbikini < Base
          include Singleton

          def initialize
            super
            @name = "ドットビキニ"
            @name_romaji = "dotbikini"
            @nicknames = []
            @play_time = 281 # 04:41
            @arrangers = ["大久保薫"]
            @hpma = HelloProjectMusicAward.new(2012, 39, 99.5, 69)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-120502-081",
              :utanet => "http://www.uta-net.com/song/129102/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 『ドットビキニ』 (MV)",
                :link => "https://www.youtube.com/watch?v=uhUFrJSDqrU",
              },
            ]
            @itunes_links = [
              {
                :title => "ドットビキニ",
                :link => "https://itunes.apple.com/jp/album/id518280736",
              },
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
