# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class OnajiJikyuuDeHatarakuTomodachiNoBijinMama < Base
          include Singleton

          def initialize
            super
            @name = "同じ時給で働く友達の美人ママ"
            @name_romaji = "onaji jikyuu de hataraku tomodachi no bijin mama"
            @nicknames = ["時給", "美人ママ"]
            @play_time = 249 # 04:09
            @arrangers = ["山崎淳"]
            @hpma = HelloProjectMusicAward.new(2010, 47, 43.5, 32)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-100929-010",
              :utanet => "http://www.uta-net.com/song/102019/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 「同じ時給で働く友達の美人ママ」 (MV)",
                :link => "https://www.youtube.com/watch?v=gJF6T7iACQg",
              },
              {
                :title => "スマイレージ 「同じ時給で働く友達の美人ママ」 (4Shot Lip Ver.)",
                :link => "https://www.youtube.com/watch?v=U4x6fCUyMLA",
              },
              {
                :title => "スマイレージ 「同じ時給で働く友達の美人ママ」 (Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=PWEeuaPqkIk",
              },
              {
                :title => "スマイレージ 「同じ時給で働く友達の美人ママ」 (和田彩花Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=UDa0YTnOsp0",
              },
              {
                :title => "スマイレージ 「同じ時給で働く友達の美人ママ」 (福田花音Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=s-dyYOHEP-4",
              },
              {
                :title => "スマイレージ 「同じ時給で働く友達の美人ママ」 (Dance Shot Ver.Pink)",
                :link => "https://www.youtube.com/watch?v=IaJOwWIx7vU",
              },
              {
                :title => "スマイレージ 「同じ時給で働く友達の美人ママ」 (アルバイトVer.)",
                :link => "https://www.youtube.com/watch?v=gv-gVn0Jbi8",
              },
              {
                :title => "スマイレージ 「同じ時給で働く友達の美人ママ」 (Dance Shot Ver.Light Blue)",
                :link => "https://www.youtube.com/watch?v=0MeXpMw4hjQ",
              },
              {
                :title => "スマイレージ 「同じ時給で働く友達の美人ママ」 (featuring 和田彩花 Ver.)",
                :link => "https://www.youtube.com/watch?v=RviN40P0B60",
              },
              {
                :title => "スマイレージ 「同じ時給で働く友達の美人ママ」 (featuring 福田花音 Ver.)",
                :link => "https://www.youtube.com/watch?v=tmwpzTmnYw4",
              },
            ]
            @itunes_links = [
              {
                :title => "同じ時給で働く友達の美人ママ",
                :link => "https://itunes.apple.com/jp/album/id390851470",
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
