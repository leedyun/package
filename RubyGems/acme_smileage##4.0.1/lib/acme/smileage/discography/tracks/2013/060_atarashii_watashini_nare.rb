# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class AtarashiiWatashiniNare < Base
          include Singleton

          def initialize
            super
            @name = "新しい私になれ！"
            @name_romaji = "atarashii watashini nare!"
            @nicknames = ["あたわた"]
            @play_time = 222 # 03:42
            @arrangers = ["江上浩太郎"]
            @hpma = HelloProjectMusicAward.new(2013, 56, 128.0, 87)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-130703-250",
              :utanet => "http://www.uta-net.com/song/148900/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 『新しい私になれ！』(S/mileage[Be the new me!]) (MV)",
                :link => "https://www.youtube.com/watch?v=yCttQlnRcOU",
              },
              {
                :title => "スマイレージ 『新しい私になれ！』(S/mileage[Be the new me!]) (Dance Shot Ver.)",
                :link => "https://www.youtube.com/watch?v=vgyLXQr49BA",
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
