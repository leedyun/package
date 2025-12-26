# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class GambaranakutemoEenendeTopnudeRemixVersion01 < Base
          include Singleton

          def initialize
            super
            @name = "○○ がんばらなくてもええねんで！！ (TopNude Remix Version 01)"
            @name_romaji = "gambaranakutemo eenende!! (topnude remix version 01)"
            @nicknames = []
            @play_time = 255 # 04:15
            @arrangers = ["高橋諭一"]
            @hpma = HelloProjectMusicAward.new(2010, 112, 5.0, 5)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-100728-116",
              :utanet => "http://www.uta-net.com/song/98771/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "○○ がんばらなくてもええねんで！！ (TopNude Remix Version 01)",
                :link => "https://itunes.apple.com/jp/album/id385082027",
              },
            ]
          end

          def remix?; true; end
        end
      end
    end
  end
end
