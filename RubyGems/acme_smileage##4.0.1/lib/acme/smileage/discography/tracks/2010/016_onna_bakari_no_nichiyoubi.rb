# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class OnnaBakariNoNichiyoubi < Base
          include Singleton

          def initialize
            super
            @name = "女ばかりの日曜日"
            @name_romaji = "onna bakari no nichiyoubi"
            @nicknames = []
            @play_time = 211 # 03:31
            @arrangers = ["鈴木俊介"]
            @hpma = HelloProjectMusicAward.new(2011, 78, 16.0, 9)
            @lyric_links = {
              :utamap => "",
              :utanet => "http://www.uta-net.com/song/105948/",
            }
            @youtube_links = []
            @itunes_links = [
              {
                :title => "悪ガキッ①",
                :link => "https://itunes.apple.com/jp/album/id403700742",
              },
            ]
          end
        end
      end
    end
  end
end
