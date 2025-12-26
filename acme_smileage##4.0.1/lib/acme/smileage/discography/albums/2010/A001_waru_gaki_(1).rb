# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class WaruGaki1 < Base
          include Singleton

          def initialize
            @name = "悪ガキッ①"
            @name_romaji = "waru gaki (1)"
            @nicknames = []
            @release_date = Date.new(2010, 12, 8)
            @oricon = Sales.new(8905, 11848, 18, 5)
            @soundscan = Sales.new(0, 0, 0, 0) # http://www.phileweb.com/ranking/cd-top20/1476.html
            @discography_link = "http://s-mileage.jp/discography/detail_00047/"
            @artwork_links = [
              {
                :title => "悪ガキッ① 【通常盤】",
                :link => "http://s-mileage.jp/discography/obj/img/000/047/101118-1624_01l.jpg",
              },
              {
                :title => "悪ガキッ① 【初回生産限定盤】",
                :link => "http://s-mileage.jp/discography/obj/img/000/047/101118-1624_02l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::OnajiJikyuuDeHatarakuTomodachiNoBijinMama
            track Acme::Smileage::Discography::Tracks::Odorouyo
            track Acme::Smileage::Discography::Tracks::OnnaBakariNoNichiyoubi
            track Acme::Smileage::Discography::Tracks::Yumemiru15sai
            track Acme::Smileage::Discography::Tracks::ShootingStar
            track Acme::Smileage::Discography::Tracks::GambaranakutemoEenende
            track Acme::Smileage::Discography::Tracks::Sukichan
            track Acme::Smileage::Discography::Tracks::GakkyuuIinchou
            track Acme::Smileage::Discography::Tracks::ShikkariShiteyoMou
            track Acme::Smileage::Discography::Tracks::OtonaNiNarutteMuzukashii
            track Acme::Smileage::Discography::Tracks::AsuhaDateNanoniImasuguKoeGaKikitai
            track Acme::Smileage::Discography::Tracks::Amanojaku
          end

          def album?; true; end
        end
      end
    end
  end
end
