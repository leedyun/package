# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class Shortcut < Base
          include Singleton

          def initialize
            super
            @name = "ショートカット"
            @name_romaji = "shortcut"
            @nicknames = []
            @play_time = 268 # 04:28
            @arrangers = ["平田祥一郎"]
            @hpma = HelloProjectMusicAward.new(2011, 4, 363.5, 175)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-110209-011",
              :utanet => "http://www.uta-net.com/song/108524/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 「ショートカット」 (MV)",
                :link => "https://www.youtube.com/watch?v=er3HL_jwOX8",
              },
              {
                :title => "スマイレージ 「ショートカット」 (Dance Shot Ver.)",
                :link => "https://www.youtube.com/watch?v=mlpwT0E0d14",
              },
              {
                :title => "スマイレージ 「ショートカット」 (Image Scene Ver.)",
                :link => "https://www.youtube.com/watch?v=Qfa0Xao02vg",
              },
              {
                :title => "スマイレージ 「ショートカット」 (salon dream Ver.)",
                :link => "https://www.youtube.com/watch?v=5I_7a_-vZL8",
              },
              {
                :title => "スマイレージ 「ショートカット」 (Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=QlCw8p02nwA",
              },
              {
                :title => "スマイレージ 「ショートカット」 (和田彩花 Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=xnE8Gf1Y-gk",
              },
              {
                :title => "スマイレージ 「ショートカット」 (福田花音 Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=gSCYdN0ZgE8",
              },
            ]
            @itunes_links = [
              {
                :title => "ショートカット",
                :link => "https://itunes.apple.com/jp/album/id417218984",
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
