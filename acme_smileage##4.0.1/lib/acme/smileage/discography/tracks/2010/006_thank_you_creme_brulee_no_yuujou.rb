# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class ThankYouCremeBruleeNoYuujou < Base
          include Singleton

          def initialize
            super
            @name = "サンキュ！ クレームブリュレの友情"
            @lyricists = ["亜伊林"]
            @name_romaji = "thank you! creme brulee no yuujou"
            @nicknames = ["クレームブリュレ"]
            @play_time = 230 # 03:50
            @arrangers = ["高橋諭一"]
            @hpma = HelloProjectMusicAward.new(2010, 42, 49.0, 31)
            @lyric_links = {
              :utamap => "http://www.utamap.com/showkasi.php?surl=k-100526-019",
              :utanet => "http://www.uta-net.com/song/95254/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "夢見る 15歳",
                :link => "https://itunes.apple.com/jp/album/id372351545",
              },
            ]
          end
        end
      end
    end
  end
end
