# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class OnajiJikyuuDeHatarakuTomodachiNoBijinMama < Base
          include Singleton

          def initialize
            @name = "同じ時給で働く友達の美人ママ"
            @name_romaji = "onaji jikyuu de hataraku tomodachi no bijin mama"
            @nicknames = ["時給", "美人ママ"]
            @release_date = Date.new(2010, 9, 29)
            @oricon = Sales.new(17998, 29533, 5, 7)
            @soundscan = Sales.new(0, 0, 0, 0) # http://www.phileweb.com/ranking/cd-top20/1455.html
            @discography_link = "http://s-mileage.jp/discography/detail_00039/"
            @artwork_links = [
              {
                :title => "同じ時給で働く友達の美人ママ 【通常盤】",
                :link => "http://s-mileage.jp/discography/obj/img/000/039/100922-1154_01l.jpg",
              },
              {
                :title => "同じ時給で働く友達の美人ママ 【初回生産限定盤A】",
                :link => "http://s-mileage.jp/discography/obj/img/000/039/100922-1154_02l.jpg",
              },
              {
                :title => "同じ時給で働く友達の美人ママ 【初回生産限定盤B】",
                :link => "http://s-mileage.jp/discography/obj/img/000/039/100922-1154_03l.jpg",
              },
              {
                :title => "同じ時給で働く友達の美人ママ 【初回生産限定盤C】",
                :link => "http://s-mileage.jp/discography/obj/img/000/039/100922-1154_04l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::OnajiJikyuuDeHatarakuTomodachiNoBijinMama
            track Acme::Smileage::Discography::Tracks::ChokottoLove
          end
        end
      end
    end
  end
end
