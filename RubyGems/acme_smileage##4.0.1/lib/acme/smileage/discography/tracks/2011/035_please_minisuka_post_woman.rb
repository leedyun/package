# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class PleaseMinisukaPostWoman < Base
          include Singleton

          def initialize
            super
            @name = "プリーズ ミニスカ ポストウーマン！"
            @name_romaji = "please minisuka post woman!"
            @nicknames = ["PMPW"]
            @play_time = 305 # 05:05
            @arrangers = ["大久保薫"]
            @hpma = HelloProjectMusicAward.new(2012, 5, 913.0, 405)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-111228-031",
              :utanet => "http://www.uta-net.com/song/123904/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 『プリーズ ミニスカ ポストウーマン！』 (MV）",
                :link => "https://www.youtube.com/watch?v=EOUi6tndJT0",
              },
            ]
            @itunes_links = [
              {
                :title => "プリーズ ミニスカ ポストウーマン！",
                :link => "https://itunes.apple.com/jp/album/id487501137",
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
