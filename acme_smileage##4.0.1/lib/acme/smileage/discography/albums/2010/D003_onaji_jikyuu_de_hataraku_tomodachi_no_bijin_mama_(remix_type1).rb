# -*- encoding: utf-8 -*-

require "acme/smileage/discography/albums/base"

module Acme
  class Smileage
    class Discography
      module Albums
        class OnajiJikyuuDeHatarakuTomodachiNoBijinMamaRemixType1 < Base
          include Singleton

          def initialize
            @name = "同じ時給で働く友達の美人ママ (Remix Type1)"
            @name_romaji = "onaji jikyuu de hataraku tomodachi no bijin mama (remix type1)"
            @nicknames = []
            @release_date = Date.new(2010, 11, 3)
            @oricon = nil
            @soundscan = nil
            @discography_link = "http://s-mileage.jp/discography/detail_00051/"
            @artwork_links = [
              {
                :title => "同じ時給で働く友達の美人ママ (Remix Type1)",
                :link => "http://s-mileage.jp/discography/obj/img/000/051/101122-1155_01l.jpg",
              },
            ]

            track Acme::Smileage::Discography::Tracks::OnajiJikyuuDeHatarakuTomodachiNoBijinMamaRemixType1
          end

          def download_only?; true; end
        end
      end
    end
  end
end
