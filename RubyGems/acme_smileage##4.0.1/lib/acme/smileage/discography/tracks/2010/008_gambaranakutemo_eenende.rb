# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class GambaranakutemoEenende < Base
          include Singleton

          def initialize
            super
            @name = "○○ がんばらなくてもええねんで！！"
            @name_romaji = "gambaranakutemo eenende!!"
            @nicknames = ["がんばら"]
            @play_time = 255 # 04:15
            @arrangers = ["高橋諭一"]
            @hpma = HelloProjectMusicAward.new(2010, 35, 66.5, 39)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-100728-116",
              :utanet => "http://www.uta-net.com/song/98771/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 「○○ がんばらなくてもええねんで！！」 (MV)",
                :link => "https://www.youtube.com/watch?v=2V1Z5vFv8JM",
              },
              {
                :title => "スマイレージ 「○○ がんばらなくてもええねんで！！」 (福田Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=5Ua93ZMtvUI",
              },
              {
                :title => "スマイレージ 「○○ がんばらなくてもええねんで！！」 (和田Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=111MEXCdgXQ",
              },
              {
                :title => "スマイレージ 「○○ がんばらなくてもええねんで！！」 (featuring　和田)",
                :link => "https://www.youtube.com/watch?v=lk6qPmbuelA",
              },
              {
                :title => "スマイレージ 「○○ がんばらなくてもええねんで！！」 (featuring　福田)",
                :link => "https://www.youtube.com/watch?v=FXXZdGCa9Ok",
              },
              {
                :title => "スマイレージ 「○○ がんばらなくてもええねんで！！」 (Another Ver.)",
                :link => "https://www.youtube.com/watch?v=iSsgx89cgSk",
              },
              {
                :title => "スマイレージ 「○○ がんばらなくてもええねんで！！」 (Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=76r-hX6y7eI",
              },
              {
                :title => "スマイレージ 「○○ がんばらなくてもええねんで！！」 (Dance Shot Ver.Black)",
                :link => "https://www.youtube.com/watch?v=EQD0w9S8gJI",
              },
              {
                :title => "スマイレージ 「○○ がんばらなくてもええねんで！！」 (Dance Shot Ver.White)",
                :link => "https://www.youtube.com/watch?v=ErqUnGS5RcA",
              },
              {
                :title => "スマイレージ 「○○ がんばらなくてもええねんで！！」 (Another Ver.)",
                :link => "https://www.youtube.com/watch?v=-MrBYK0bdC8",
              },
            ]
            @itunes_links = [
              {
                :title => "○○ がんばらなくてもええねんで！！",
                :link => "https://itunes.apple.com/jp/album/id382386730",
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
