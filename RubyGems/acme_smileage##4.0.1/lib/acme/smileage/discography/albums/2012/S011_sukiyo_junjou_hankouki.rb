# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class SukiyoJunjouHankouki < Base
          include Singleton

          def initialize
            @name = "好きよ、純情反抗期。"
            @name_romaji = "sukiyo, junjou hankouki."
            @nicknames = ["好き純"]
            @release_date = Date.new(2012, 8, 22)
            @oricon = Sales.new(22866, 24508, 7, 3)
            @soundscan = Sales.new(6320, 6320, 18, 1) # http://www.phileweb.com/ranking/cd-top20/1654.html
            @discography_link = "http://s-mileage.jp/discography/detail_00116/"
            @artwork_links = [
              {
                :title => "好きよ、純情反抗期。 【通常盤】",
                :link => "http://s-mileage.jp/discography/obj/img/000/116/120730-1512_01l.jpg",
              },
              {
                :title => "好きよ、純情反抗期。 【初回生産限定盤A】",
                :link => "http://s-mileage.jp/discography/obj/img/000/116/120730-1512_02l.jpg",
              },
              {
                :title => "好きよ、純情反抗期。 【初回生産限定盤B】",
                :link => "http://s-mileage.jp/discography/obj/img/000/116/120730-1512_03l.jpg",
              },
              {
                :title => "好きよ、純情反抗期。 【初回生産限定盤C】",
                :link => "http://s-mileage.jp/discography/obj/img/000/116/120730-1512_04l.jpg",
              },
              {
                :title => "好きよ、純情反抗期。 【初回生産限定盤D】",
                :link => "http://s-mileage.jp/discography/obj/img/000/116/120730-1512_05l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::SukiyoJunjouHankouki
            track Acme::Smileage::Discography::Tracks::KimiHaJitenshaWatasiHaDensyaDeKitaku
          end
        end
      end
    end
  end
end
