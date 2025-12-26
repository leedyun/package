# -*- encoding: utf-8 -*-

require "acme/smileage/discography/tracks/base"

module Acme
  class Smileage
    class Discography
      module Tracks
        class SmileageSinglesGekimoeRemix < Base
          include Singleton

          def initialize
            super
            @name = "スマイレージ シングルス 激萌えリミックス"
            @name_romaji = "smileage singles gekimoe remix"
            @nicknames = []
            @play_time = 336 # 05:36
            @arrangers = ["田中直"]
            @hpma = HelloProjectMusicAward.new(2011, 121, 4.5, 3)
            @lyric_links = {}
            @youtube_links = []
            @itunes_links = [
              {
                :title => "タチアガール",
                :link => "https://itunes.apple.com/jp/album/id464723016",
              },
            ]
          end

          def remix?; true; end
        end
      end
    end
  end
end
