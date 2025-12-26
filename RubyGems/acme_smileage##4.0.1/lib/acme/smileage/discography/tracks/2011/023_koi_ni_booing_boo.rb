# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class KoiNiBooingBoo < Base
          include Singleton

          def initialize
            super
            @name = "恋にBooing ブー！"
            @name_romaji = "koi ni booing boo!"
            @nicknames = ["恋ブー"]
            @play_time = 264 # 04:24
            @arrangers = ["山崎淳"]
            @hpma = HelloProjectMusicAward.new(2011, 79, 14.5, 11)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-110427-198",
              :utanet => "http://www.uta-net.com/song/112183/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 『恋にBooing ブー！』 (MV)",
                :link => "https://www.youtube.com/watch?v=khFjQDiCKE4",
              },
              {
                :title => "スマイレージ 『恋にBooing ブー！』 (Dance Shot Ver.)",
                :link => "https://www.youtube.com/watch?v=W-iE21ANDJQ",
              },
              {
                :title => "スマイレージ 『恋にBooing ブー！』 (Boo Ver.)",
                :link => "https://www.youtube.com/watch?v=d6iixBrklNY",
              },
              {
                :title => "スマイレージ 『恋にBooing ブー！』 (Black Ver.)",
                :link => "https://www.youtube.com/watch?v=PdxQgiU4Kj8",
              },
              {
                :title => "スマイレージ 『恋にBooing ブー！』 (Dance &amp; Image Ver.)",
                :link => "https://www.youtube.com/watch?v=nv8wcsF483Q",
              },
              {
                :title => "スマイレージ 『恋にBooing ブー！』 (和田彩花 Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=Dd26kQUZ6QA",
              },
              {
                :title => "スマイレージ 『恋にBooing ブー！』 (福田花音 Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=Wyc7V5o10sA",
              },
            ]
            @itunes_links = [
              {
                :title => "恋にBooing ブー！",
                :link => "https://itunes.apple.com/jp/album/id429866286",
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
