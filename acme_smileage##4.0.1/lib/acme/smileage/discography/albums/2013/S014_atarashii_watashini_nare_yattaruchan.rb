# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class AtarashiiWatashiniNare_Yattaruchan < Base
          include Singleton

          def initialize
            @name = "新しい私になれ！／ヤッタルチャン"
            @name_romaji = "atarashii watashini nare!/yattaruchan"
            @nicknames = ["あたわた", "ヤッタル"]
            @release_date = Date.new(2013, 7, 3)
            @oricon = Sales.new(26573, 27935, 4, 3)
            @soundscan = Sales.new(8922, 8922, 9, 1) # http://www.phileweb.com/ranking/cd-top20/1744.html
            @discography_link = "http://s-mileage.jp/discography/detail_00149/"
            @artwork_links = [
              {
                :title => "新しい私になれ！／ヤッタルチャン 【通常盤】",
                :link => "http://s-mileage.jp/discography/obj/img/000/149/130613-1235_01l.jpg",
              },
              {
                :title => "新しい私になれ！／ヤッタルチャン 【初回生産限定盤A】",
                :link => "http://s-mileage.jp/discography/obj/img/000/149/130613-1235_02l.jpg",
              },
              {
                :title => "新しい私になれ！／ヤッタルチャン 【初回生産限定盤B】",
                :link => "http://s-mileage.jp/discography/obj/img/000/149/130613-1235_03l.jpg",
              },
              {
                :title => "新しい私になれ！／ヤッタルチャン 【初回生産限定盤C】",
                :link => "http://s-mileage.jp/discography/obj/img/000/149/130613-1235_04l.jpg",
              },
              {
                :title => "新しい私になれ！／ヤッタルチャン 【初回生産限定盤D】",
                :link => "http://s-mileage.jp/discography/obj/img/000/149/130613-1235_05l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::AtarashiiWatashiniNare
            track Acme::Smileage::Discography::Tracks::Yattaruchan
          end
        end
      end
    end
  end
end
