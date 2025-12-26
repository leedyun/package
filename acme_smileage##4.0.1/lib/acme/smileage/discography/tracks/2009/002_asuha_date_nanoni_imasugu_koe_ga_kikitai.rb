# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class AsuhaDateNanoniImasuguKoeGaKikitai < Base
          include Singleton

          def initialize
            super
            @name = "あすはデートなのに、今すぐ声が聞きたい"
            @name_romaji = "asuha date nanoni imasugu koe ga kikitai"
            @nicknames = ["あすデー"]
            @play_time = 265 # 04:25
            @arrangers = ["AKIRA"]
            @hpma = HelloProjectMusicAward.new(2009, 26, 107.5, 63)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-101208-050",
              :utanet => "http://www.uta-net.com/song/105943/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 「あすはデートなのに、今すぐ声が聞きたい」 (MV)",
                :link => "https://www.youtube.com/watch?v=CYMW2EBjb8c",
              },
              {
                :title => "スマイレージ 「あすはデートなのに、今すぐ声が聞きたい」 (Dance Shot Ver.)",
                :link => "https://www.youtube.com/watch?v=XD7dNcacyig",
              },
              {
                :title => "スマイレージ 「あすはデートなのに、今すぐ声が聞きたい」 (Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=uMAvtxu0Sz8",
              },
            ]
            @itunes_links = [
              {
                :title => "あすはデートなのに、今すぐ声が聞きたい",
                :link => "https://itunes.apple.com/jp/album/id348593533",
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
