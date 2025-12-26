# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class Yattaruchan < Base
          include Singleton

          def initialize
            super
            @name = "ヤッタルチャン"
            @name_romaji = "yattaruchan"
            @nicknames = ["ヤッタル"]
            @play_time = 231 # 03:51
            @arrangers = ["大久保薫"]
            @hpma = HelloProjectMusicAward.new(2013, 2, 2343.5, 939)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-130703-251",
              :utanet => "http://www.uta-net.com/song/148899/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 『ヤッタルチャン』(S/mileage[Yattaruchan]) (MV)",
                :link => "https://www.youtube.com/watch?v=emiJ1iGih6U",
              },
              {
                :title => "スマイレージ 『ヤッタルチャン』(S/mileage[Yattaruchan]) (Dance Shot Ver.)",
                :link => "https://www.youtube.com/watch?v=fwpjnUSvyKk",
              },
            ]
            @itunes_links = [
              {
                :title => "新しい私になれ！／ヤッタルチャン",
                :link => "https://itunes.apple.com/jp/album/id663131682",
              },
            ]
          end
        end
      end
    end
  end
end
