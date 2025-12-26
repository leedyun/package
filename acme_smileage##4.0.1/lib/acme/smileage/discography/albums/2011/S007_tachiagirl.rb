# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class Tachiagirl < Base
          include Singleton

          def initialize
            @name = "タチアガール"
            @name_romaji = "tachiagirl"
            @nicknames = []
            @release_date = Date.new(2011, 9, 28)
            @oricon = Sales.new(22792, 26328, 4, 4)
            @soundscan = Sales.new(4585, 4585, 14, 1) # http://www.phileweb.com/ranking/cd-top20/1560.html
            @discography_link = "http://s-mileage.jp/discography/detail_00080/"
            @artwork_links = [
              {
                :title => "タチアガール 【通常盤】",
                :link => "http://s-mileage.jp/discography/obj/img/000/080/110906-1628_01l.jpg",
              },
              {
                :title => "タチアガール 【初回生産限定盤A】",
                :link => "http://s-mileage.jp/discography/obj/img/000/080/110906-1628_02l.jpg",
              },
              {
                :title => "タチアガール 【初回生産限定盤B】",
                :link => "http://s-mileage.jp/discography/obj/img/000/080/110906-1628_03l.jpg",
              },
              {
                :title => "タチアガール 【初回生産限定盤C】",
                :link => "http://s-mileage.jp/discography/obj/img/000/080/110906-1628_04l.jpg",
              },
              {
                :title => "タチアガール 【初回生産限定盤D】",
                :link => "http://s-mileage.jp/discography/obj/img/000/080/110906-1628_05l.jpg",
              },
              {
                :title => "タチアガール 【初回生産限定盤E】",
                :link => "http://s-mileage.jp/discography/obj/img/000/080/110906-1628_06l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::Tachiagirl
            track Acme::Smileage::Discography::Tracks::SmileOndon
            track Acme::Smileage::Discography::Tracks::BoogieTrain11
            track Acme::Smileage::Discography::Tracks::SmileageSinglesGekimoeRemix
          end
        end
      end
    end
  end
end
