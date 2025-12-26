# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class TabidachiNoHaruGaKita < Base
          include Singleton

          def initialize
            @name = "旅立ちの春が来た"
            @name_romaji = "tabidachi no haru ga kita"
            @nicknames = ["旅春"]
            @release_date = Date.new(2013, 3, 20)
            @oricon = Sales.new(22560, 24289, 4, 3)
            @soundscan = Sales.new(6260, 6260, 20, 1) # http://www.phileweb.com/ranking/cd-top20/1714.html
            @discography_link = "http://s-mileage.jp/discography/detail_00138/"
            @artwork_links = [
              {
                :title => "旅立ちの春が来た 【通常盤】",
                :link => "http://s-mileage.jp/discography/obj/img/000/138/130227-1335_01l.jpg",
              },
              {
                :title => "旅立ちの春が来た 【初回生産限定盤A】",
                :link => "http://s-mileage.jp/discography/obj/img/000/138/130227-1335_02l.jpg",
              },
              {
                :title => "旅立ちの春が来た 【初回生産限定盤B】",
                :link => "http://s-mileage.jp/discography/obj/img/000/138/130227-1335_03l.jpg",
              },
              {
                :title => "旅立ちの春が来た 【初回生産限定盤C】",
                :link => "http://s-mileage.jp/discography/obj/img/000/138/130227-1335_04l.jpg",
              },
              {
                :title => "旅立ちの春が来た 【初回生産限定盤D】",
                :link => "http://s-mileage.jp/discography/obj/img/000/138/130227-1335_05l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::TabidachiNoHaruGaKita
            track Acme::Smileage::Discography::Tracks::Doushiyou
          end
        end
      end
    end
  end
end
