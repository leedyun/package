# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class SmileSensation < Base
          include Singleton

          def initialize
            @name = "②スマイルセンセーション"
            @name_romaji = "(2) smile sensation"
            @nicknames = ["スマセン"]
            @release_date = Date.new(2013, 5, 22)
            @oricon = Sales.new(6199, 7091, 13, 3)
            @soundscan = Sales.new(0, 0, 0, 0) # http://www.phileweb.com/ranking/cd-top20/1733.html
            @discography_link = "http://s-mileage.jp/discography/detail_00146/"
            @artwork_links = [
              {
                :title => "②スマイルセンセーション 【通常盤】",
                :link => "http://s-mileage.jp/discography/obj/img/000/146/130425-1954_01l.jpg",
              },
              {
                :title => "②スマイルセンセーション 【初回生産限定盤】",
                :link => "http://s-mileage.jp/discography/obj/img/000/146/130425-1954_02l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::ShinNihonNoSusume
            track Acme::Smileage::Discography::Tracks::TabidachiNoHaruGaKita
            track Acme::Smileage::Discography::Tracks::OtonaNoTochuu
            track Acme::Smileage::Discography::Tracks::TenshinRamman
            track Acme::Smileage::Discography::Tracks::SukiyoJunjouHankouki
            track Acme::Smileage::Discography::Tracks::WatashiNoKokoro
            track Acme::Smileage::Discography::Tracks::YuugureKoiNoJikan
            track Acme::Smileage::Discography::Tracks::NeeSempai
            track Acme::Smileage::Discography::Tracks::SayonaraSayonaraSayonara
            track Acme::Smileage::Discography::Tracks::Samuine
          end

          def album?; true; end
        end
      end
    end
  end
end
