# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class GambaranakutemoEenendeTopnudeRemixVersion01 < Base
          include Singleton

          def initialize
            @name = "○○ がんばらなくてもええねんで！！ (TopNude Remix Version 01)"
            @name_romaji = "gambaranakutemo eenende!! (topnude remix version 01)"
            @nicknames = []
            @release_date = Date.new(2010, 8, 7)
            @oricon = nil
            @soundscan = nil
            @discography_link = "http://s-mileage.jp/discography/detail_00037/"
            @artwork_links = [
              {
                :title => "○○ がんばらなくてもええねんで！！ (TopNude Remix Version 01)",
                :link => "http://s-mileage.jp/discography/obj/img/000/037/100806-1845_01l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::GambaranakutemoEenendeTopnudeRemixVersion01
          end

          def download_only?; true; end
        end
      end
    end
  end
end
