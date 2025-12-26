# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class SmleageBestAlbumComplete1 < Base
          include Singleton

          def initialize
            @name = "スマイレージ ベストアルバム完全版①"
            @name_romaji = "smleage best album complete (1)"
            @nicknames = []
            @release_date = Date.new(2012, 5, 30)
            @oricon = Sales.new(6339, 8095, 13, 3)
            @soundscan = Sales.new(0, 0, 0, 0) # http://www.phileweb.com/ranking/cd-top20/1631.html
            @discography_link = "http://s-mileage.jp/discography/detail_00114/"
            @artwork_links = [
              {
                :title => "スマイレージ ベストアルバム完全版① 【通常盤】",
                :link => "http://s-mileage.jp/discography/obj/img/000/114/120502-2111_01l.jpg",
              },
              {
                :title => "スマイレージ ベストアルバム完全版① 【初回生産限定盤】",
                :link => "http://s-mileage.jp/discography/obj/img/000/114/120502-2111_02l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::Dotbikini
            track Acme::Smileage::Discography::Tracks::ChotoMateKudasai
            track Acme::Smileage::Discography::Tracks::PleaseMinisukaPostWoman
            track Acme::Smileage::Discography::Tracks::Tachiagirl
            track Acme::Smileage::Discography::Tracks::UchoutenLove
            track Acme::Smileage::Discography::Tracks::KoiNiBooingBoo
            track Acme::Smileage::Discography::Tracks::Shortcut
            track Acme::Smileage::Discography::Tracks::OnajiJikyuuDeHatarakuTomodachiNoBijinMama
            track Acme::Smileage::Discography::Tracks::GambaranakutemoEenende
            track Acme::Smileage::Discography::Tracks::Yumemiru15sai
            track Acme::Smileage::Discography::Tracks::OtonaNiNarutteMuzukashii
            track Acme::Smileage::Discography::Tracks::Sukichan
            track Acme::Smileage::Discography::Tracks::AsuhaDateNanoniImasuguKoeGaKikitai
            track Acme::Smileage::Discography::Tracks::Amanojaku
            track Acme::Smileage::Discography::Tracks::KiiroiJitenshaToSandwich
          end

          def album?; true; end
          def best_album?; true; end
        end
      end
    end
  end
end
