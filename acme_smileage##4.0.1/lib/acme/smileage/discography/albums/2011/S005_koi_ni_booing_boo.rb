# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class KoiNiBooingBoo < Base
          include Singleton

          def initialize
            @name = "恋にBooing ブー！"
            @name_romaji = "koi ni booing boo!"
            @nicknames = ["恋ブー"]
            @release_date = Date.new(2011, 4, 27)
            @oricon = Sales.new(19049, 20954, 6, 3)
            @soundscan = Sales.new(0, 0, 0, 0) # http://www.phileweb.com/ranking/cd-top20/1516.html
            @discography_link = "http://s-mileage.jp/discography/detail_00068/"
            @artwork_links = [
              {
                :title => "恋にBooing ブー！ 【通常盤】",
                :link => "http://s-mileage.jp/discography/obj/img/000/068/110331-2058_01l.jpg",
              },
              {
                :title => "恋にBooing ブー！ 【初回生産限定盤A】",
                :link => "http://s-mileage.jp/discography/obj/img/000/068/110331-2058_02l.jpg",
              },
              {
                :title => "恋にBooing ブー！ 【初回生産限定盤B】",
                :link => "http://s-mileage.jp/discography/obj/img/000/068/110331-2058_03l.jpg",
              },
              {
                :title => "恋にBooing ブー！ 【初回生産限定盤C】",
                :link => "http://s-mileage.jp/discography/obj/img/000/068/110331-2058_04l.jpg",
              },
              {
                :title => "恋にBooing ブー！ 【初回生産限定盤D】",
                :link => "http://s-mileage.jp/discography/obj/img/000/068/110331-2058_05l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::KoiNiBooingBoo
            track Acme::Smileage::Discography::Tracks::HatukoiNoAnatahe
            track Acme::Smileage::Discography::Tracks::KoiWoShichaimashita
          end
        end
      end
    end
  end
end
