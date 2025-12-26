# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class Dotbikini < Base
          include Singleton

          def initialize
            @name = "ドットビキニ"
            @name_romaji = "dotbikini"
            @nicknames = []
            @release_date = Date.new(2012, 5, 2)
            @oricon = Sales.new(20043, 22133, 6, 3)
            @soundscan = Sales.new(0, 0, 0, 0) # http://www.phileweb.com/ranking/cd-top20/1622.html
            @discography_link = "http://s-mileage.jp/discography/detail_00109/"
            @artwork_links = [
              {
                :title => "ドットビキニ 【通常盤】",
                :link => "http://s-mileage.jp/discography/obj/img/000/109/120405-2112_01l.jpg",
              },
              {
                :title => "ドットビキニ 【初回生産限定盤A】",
                :link => "http://s-mileage.jp/discography/obj/img/000/109/120405-2112_02l.jpg",
              },
              {
                :title => "ドットビキニ 【初回生産限定盤B】",
                :link => "http://s-mileage.jp/discography/obj/img/000/109/120405-2112_03l.jpg",
              },
              {
                :title => "ドットビキニ 【初回生産限定盤C】",
                :link => "http://s-mileage.jp/discography/obj/img/000/109/120405-2112_04l.jpg",
              },
              {
                :title => "ドットビキニ 【初回生産限定盤D】",
                :link => "http://s-mileage.jp/discography/obj/img/000/109/120405-2112_05l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::Dotbikini
            track Acme::Smileage::Discography::Tracks::SmileBlues
            track Acme::Smileage::Discography::Tracks::KoibitoHaKokoroNoOuendan
          end
        end
      end
    end
  end
end
