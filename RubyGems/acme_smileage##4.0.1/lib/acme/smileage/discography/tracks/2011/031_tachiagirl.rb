# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class Tachiagirl < Base
          include Singleton

          def initialize
            super
            @name = "タチアガール"
            @name_romaji = "tachiagirl"
            @nicknames = []
            @play_time = 273 # 04:33
            @arrangers = ["平田祥一郎"]
            @hpma = HelloProjectMusicAward.new(2011, 17, 169.0, 102)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-110928-016",
              :utanet => "http://www.uta-net.com/song/119200/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 『タチアガール』 (MV)",
                :link => "https://www.youtube.com/watch?v=LN9mG9oqqfc",
              },
              {
                :title => "スマイレージ 『タチアガール』 (Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=yo73sdVef4Q",
              },
              {
                :title => "スマイレージ 『タチアガール』 (DanceShot Ver.)",
                :link => "https://www.youtube.com/watch?v=Uk_0ysc_ed0",
              },
              {
                :title => "スマイレージ 『タチアガール』 (悪ガキッ Ver.)",
                :link => "https://www.youtube.com/watch?v=GlMvlqZ_MFE",
              },
              {
                :title => "スマイレージ 『タチアガール』 (1期メンバー Ver.)",
                :link => "https://www.youtube.com/watch?v=B0Nalrrru68",
              },
              {
                :title => "スマイレージ 『タチアガール』 (和田彩花 Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=x89lMPI3BRY",
              },
              {
                :title => "スマイレージ 『タチアガール』 (福田花音Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=qTgmUBpH8SY",
              },
              {
                :title => "スマイレージ 『タチアガール』 (サブメンVer.)",
                :link => "https://www.youtube.com/watch?v=tITHkHXQWvU",
              },
            ]
            @itunes_links = [
              {
                :title => "タチアガール",
                :link => "https://itunes.apple.com/jp/album/id464722574",
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
