# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class ChotoMateKudasai < Base
          include Singleton

          def initialize
            @name = "チョトマテクダサイ！"
            @name_romaji = "choto mate kudasai!"
            @nicknames = ["チョトマテ"]
            @release_date = Date.new(2012, 2, 1)
            @oricon = Sales.new(19700, 22106, 6, 3)
            @soundscan = Sales.new(6022, 6022, 13, 1) # http://www.phileweb.com/ranking/cd-top20/1596.html
            @discography_link = "http://s-mileage.jp/discography/detail_00101/"
            @artwork_links = [
              {
                :title => "チョトマテクダサイ！ 【通常盤】",
                :link => "http://s-mileage.jp/discography/obj/img/000/101/120111-1343_01l.jpg",
              },
              {
                :title => "チョトマテクダサイ！ 【初回生産限定盤A】",
                :link => "http://s-mileage.jp/discography/obj/img/000/101/120111-1343_02l.jpg",
              },
              {
                :title => "チョトマテクダサイ！ 【初回生産限定盤B】",
                :link => "http://s-mileage.jp/discography/obj/img/000/101/120111-1343_03l.jpg",
              },
              {
                :title => "チョトマテクダサイ！ 【初回生産限定盤C】",
                :link => "http://s-mileage.jp/discography/obj/img/000/101/120111-1343_04l.jpg",
              },
              {
                :title => "チョトマテクダサイ！ 【初回生産限定盤D】",
                :link => "http://s-mileage.jp/discography/obj/img/000/101/120111-1343_05l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::ChotoMateKudasai
            track Acme::Smileage::Discography::Tracks::ChanceTourai
            track Acme::Smileage::Discography::Tracks::SmileageSinglesGekiatsuRemix
            track Acme::Smileage::Discography::Tracks::NamidaGirl
          end
        end
      end
    end
  end
end
