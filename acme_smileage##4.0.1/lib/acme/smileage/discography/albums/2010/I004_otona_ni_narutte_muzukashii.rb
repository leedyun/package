# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class OtonaNiNarutteMuzukashii < Base
          include Singleton

          def initialize
            @name = "オトナになるって難しい！！！"
            @name_romaji = "otona ni narutte muzukashii!!!"
            @nicknames = ["オトムズ", "オトむず"]
            @release_date = Date.new(2010, 3, 14)
            @oricon = Sales.new(1324, 2290, 42, 3)
            @soundscan = Sales.new(0, 0, 0, 0) # http://www.phileweb.com/ranking/cd-top20/1397.html
            @discography_link = "http://s-mileage.jp/discography/detail_00014/"
            @artwork_links = [
              {
                :title => "オトナになるって難しい！！！",
                :link => "http://s-mileage.jp/discography/obj/img/000/014/100922-1208_01l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::OtonaNiNarutteMuzukashii
          end

          def indies?; true; end
        end
      end
    end
  end
end
