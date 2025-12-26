# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class UchoutenLove < Base
          include Singleton

          def initialize
            super
            @name = "有頂天LOVE"
            @name_romaji = "uchouten love"
            @nicknames = ["有頂天"]
            @play_time = 257 # 04:17
            @arrangers = ["大久保薫"]
            @hpma = HelloProjectMusicAward.new(2011, 1, 749.5, 305)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-110810-160",
              :utanet => "http://www.uta-net.com/song/116848/",
            }
            @youtube_links = [
              {
                :title => "スマイレージ 『有頂天LOVE』 (Music only)",
                :link => "https://www.youtube.com/watch?v=eDDfSMxpfoU",
              },
              {
                :title => "スマイレージ 『有頂天LOVE』 (MV)",
                :link => "https://www.youtube.com/watch?v=iqKryI3Sl4U",
              },
              {
                :title => "スマイレージ 『有頂天LOVE』 (Dance Ver.2)",
                :link => "https://www.youtube.com/watch?v=vdCSPnGu-UM",
              },
              {
                :title => "スマイレージ 『有頂天LOVE』 (Dance Shot Ver.)",
                :link => "https://www.youtube.com/watch?v=V0Tb1A2Ee3c",
              },
              {
                :title => "スマイレージ 『有頂天LOVE』 (4Shot Lip Ver.)",
                :link => "https://www.youtube.com/watch?v=etCxoeJCS8U",
              },
              {
                :title => "スマイレージ 『有頂天LOVE』 (校歌斉唱 Ver.)",
                :link => "https://www.youtube.com/watch?v=csCpvG6ficU",
              },
              {
                :title => "スマイレージ 『有頂天LOVE』 (Deco Mic Ver.)",
                :link => "https://www.youtube.com/watch?v=fqA94FMN2zY",
              },
              {
                :title => "スマイレージ 『有頂天LOVE』 (和田彩花 超Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=GONClIuLUw8",
              },
              {
                :title => "スマイレージ 『有頂天LOVE』 (福田花音 超Close-up Ver.)",
                :link => "https://www.youtube.com/watch?v=ly-6RS34nqc",
              },
            ]
            @itunes_links = [
              {
                :title => "有頂天LOVE",
                :link => "https://itunes.apple.com/jp/album/id449821345",
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
