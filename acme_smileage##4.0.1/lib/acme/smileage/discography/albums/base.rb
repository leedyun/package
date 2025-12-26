require "date"
require "singleton"

require "acme/smileage/discography/sales"

module Acme
  class Smileage
    class Discography
      module Albums
        class Base
          attr_reader :name, :name_romaji, :nicknames, :release_date, :artwork_links, :discography_link
          attr_reader :oricon, :soundscan
          attr_reader :tracks

          def release_year; self.release_date.year; end

          def single?; not album? and not download_only?; end
          def album?; false; end
          def best_album?; false; end
          def original_album?; album? and not best_album?; end

          def major?; not indies?; end
          def indies?; false; end

          def download_only?; false; end

          private

          def track(track_class)
            @tracks ||= []
            @tracks << track_class.instance
          end
        end
      end
    end
  end
end
