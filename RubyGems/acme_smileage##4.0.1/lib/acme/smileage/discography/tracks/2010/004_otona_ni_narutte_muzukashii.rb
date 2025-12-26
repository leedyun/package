# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class OtonaNiNarutteMuzukashii < Base
          include Singleton

          def initialize
            super
            @name = "オトナになるって難しい！！！"
            @name_romaji = "otona ni narutte muzukashii!!!"
            @nicknames = ["オトムズ", "オトむず"]
            @play_time = 186 # 03:06
            @arrangers = ["板垣祐介"]
            @hpma = HelloProjectMusicAward.new(2010, 29, 77.5, 48)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=dk100527_6",
              :utanet => "http://www.uta-net.com/song/91873/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 「オトナになるって難しい！！！」 (MV)",
                :link => "https://www.youtube.com/watch?v=LNpIGK_klbA",
              },
              {
                :title => "スマイレージ 「オトナになるって難しい！！！」 (Dance Shot Ver.)",
                :link => "https://www.youtube.com/watch?v=-WaavRLtAqI",
              },
              {
                :title => "スマイレージ 「オトナになるって難しい！！！」 (Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=_gs6j31SGbw",
              },
            ]
            @itunes_links = [
              {
                :title => "オトナになるって難しい！！！",
                :link => "https://itunes.apple.com/jp/album/id366438599",
              },
              {
                :title => "悪ガキッ①",
                :link => "https://itunes.apple.com/jp/album/id403700742",
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
