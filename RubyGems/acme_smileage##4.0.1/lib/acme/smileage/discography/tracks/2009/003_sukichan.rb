# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class Sukichan < Base
          include Singleton

          def initialize
            super
            @name = "スキちゃん"
            @name_romaji = "sukichan"
            @nicknames = []
            @play_time = 206 # 03:26
            @arrangers = ["板垣祐介"]
            @hpma = HelloProjectMusicAward.new(2009, 51, 41.0, 19)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-101208-047",
              :utanet => "http://www.uta-net.com/song/105946/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 「スキちゃん」 (MV)",
                :link => "https://www.youtube.com/watch?v=TuTO6edKwLU",
              },
              {
                :title => "スマイレージ 「スキちゃん」 (Dance Shot Ver.)",
                :link => "https://www.youtube.com/watch?v=YzotAomnYa0",
              },
              {
                :title => "スマイレージ 「スキちゃん」 (Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=EHAp-v83Ulo",
              },
            ]
            @itunes_links = [
              {
                :title => "スキちゃん",
                :link => "https://itunes.apple.com/jp/album/id349411000",
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
