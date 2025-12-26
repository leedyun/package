# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class Sukichan < Base
          include Singleton

          def initialize
            @name = "スキちゃん"
            @name_romaji = "sukichan"
            @nicknames = []
            @release_date = Date.new(2009, 11, 23)
            @oricon = Sales.new(399, 399, 159, 1)
            @soundscan = Sales.new(0, 0, 0, 0) # http://www.phileweb.com/ranking/cd-top20/1367.html
            @discography_link = "http://s-mileage.jp/discography/detail_00001/"
            @artwork_links = [
              {
                :title => "スキちゃん",
                :link => "http://s-mileage.jp/discography/obj/img/000/001/100922-1207_01l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::Sukichan
          end

          def indies?; true; end
        end
      end
    end
  end
end
