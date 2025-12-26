# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class UchoutenLove < Base
          include Singleton

          def initialize
            @name = "有頂天LOVE"
            @name_romaji = "uchouten love"
            @nicknames = ["有頂天"]
            @release_date = Date.new(2011, 8, 3)
            @oricon = Sales.new(29328, 33823, 5, 4)
            @soundscan = Sales.new(6484, 6484, 18, 1) # http://www.phileweb.com/ranking/cd-top20/1544.html
            @discography_link = "http://s-mileage.jp/discography/detail_00076/"
            @artwork_links = [
              {
                :title => "有頂天LOVE 【通常盤】",
                :link => "http://s-mileage.jp/discography/obj/img/000/076/110708-1520_01l.jpg",
              },
              {
                :title => "有頂天LOVE 【初回生産限定盤A】",
                :link => "http://s-mileage.jp/discography/obj/img/000/076/110708-1520_02l.jpg",
              },
              {
                :title => "有頂天LOVE 【初回生産限定盤B】",
                :link => "http://s-mileage.jp/discography/obj/img/000/076/110708-1520_03l.jpg",
              },
              {
                :title => "有頂天LOVE 【初回生産限定盤C】",
                :link => "http://s-mileage.jp/discography/obj/img/000/076/110708-1520_04l.jpg",
              },
              {
                :title => "有頂天LOVE 【初回生産限定盤D】",
                :link => "http://s-mileage.jp/discography/obj/img/000/076/110708-1520_05l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::UchoutenLove
            track Acme::Smileage::Discography::Tracks::JitenshaChiririn
            track Acme::Smileage::Discography::Tracks::ChuNatsuParty
          end
        end
      end
    end
  end
end
