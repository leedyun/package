# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class Yumemiru15saiPaxJaponicaGrooveRemix < Base
          include Singleton

          def initialize
            @name = "夢見る 15歳 (PAX JAPONICA GROOVE REMIX)"
            @name_romaji = "yumemiru 15sai (pax japonica groove remix)"
            @nicknames = []
            @release_date = Date.new(2010, 6, 18)
            @oricon = nil
            @soundscan = nil
            @discography_link = "http://s-mileage.jp/discography/detail_00032/"
            @artwork_links = [
              {
                :title => "夢見る 15歳 (PAX JAPONICA GROOVE REMIX)",
                :link => "http://s-mileage.jp/discography/obj/img/000/032/100709-1334_01l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::Yumemiru15saiPaxJaponicaGrooveRemix
          end

          def download_only?; true; end
        end
      end
    end
  end
end
