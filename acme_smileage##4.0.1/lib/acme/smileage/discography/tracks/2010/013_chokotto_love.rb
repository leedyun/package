# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class ChokottoLove < Base
          include Singleton

          def initialize
            super
            @name = "ちょこっとLOVE"
            @name_romaji = "chokotto love"
            @nicknames = ["ちょこラブ", "ちょこLOVE"]
            @play_time = 243 # 04:03
            @arrangers = ["鈴木俊介"]
            @hpma = HelloProjectMusicAward.new(2010, 121, 4.0, 3)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-100929-011",
              :utanet => "http://www.uta-net.com/song/102018/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "同じ時給で働く友達の美人ママ",
                :link => "https://itunes.apple.com/jp/album/id390851470",
              },
            ]
          end

          def cover?; true; end
        end
      end
    end
  end
end
