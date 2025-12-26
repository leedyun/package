# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class GambaranakutemoEenende < Base
          include Singleton

          def initialize
            @name = "○○ がんばらなくてもええねんで！！"
            @name_romaji = "gambaranakutemo eenende!!"
            @nicknames = ["がんばら"]
            @release_date = Date.new(2010, 7, 28)
            @oricon = Sales.new(18987, 24489, 6, 4)
            @soundscan = Sales.new(0, 0, 0, 0) # http://www.phileweb.com/ranking/cd-top20/1437.html
            @discography_link = "http://s-mileage.jp/discography/detail_00021/"
            @artwork_links = [
              {
                :title => "○○ がんばらなくてもええねんで！！ 【通常盤】",
                :link => "http://s-mileage.jp/discography/obj/img/000/021/100922-1203_01l.jpg",
              },
              {
                :title => "○○ がんばらなくてもええねんで！！ 【初回生産限定盤A】",
                :link => "http://s-mileage.jp/discography/obj/img/000/021/100922-1203_02l.jpg",
              },
              {
                :title => "○○ がんばらなくてもええねんで！！ 【初回生産限定盤B】",
                :link => "http://s-mileage.jp/discography/obj/img/000/021/100922-1203_03l.jpg",
              },
              {
                :title => "○○ がんばらなくてもええねんで！！ 【初回生産限定盤C】",
                :link => "http://s-mileage.jp/discography/obj/img/000/021/100922-1203_04l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::GambaranakutemoEenende
            track Acme::Smileage::Discography::Tracks::GambaranakutemoIindayo
            track Acme::Smileage::Discography::Tracks::SmileBijin
          end
        end
      end
    end
  end
end
