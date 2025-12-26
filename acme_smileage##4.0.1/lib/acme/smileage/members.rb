require "acme/smileage/members/wada_ayaka"
require "acme/smileage/members/fukuda_kanon"
require "acme/smileage/members/nakanishi_kana"
require "acme/smileage/members/takeuchi_akari"
require "acme/smileage/members/katsuta_rina"
require "acme/smileage/members/tamura_meimi"

require "acme/smileage/members/maeda_yuuka"
require "acme/smileage/members/ogawa_saki"
require "acme/smileage/members/kosuga_fuyuka"

module Acme
  class Smileage
    class Members
      include Enumerable

      attr_reader :members

      def initialize
        @members = []
        @members << Acme::Smileage::Members::WadaAyaka.new
        @members << Acme::Smileage::Members::FukudaKanon.new
        @members << Acme::Smileage::Members::NakanishiKana.new
        @members << Acme::Smileage::Members::TakeuchiAkari.new
        @members << Acme::Smileage::Members::KatsutaRina.new
        @members << Acme::Smileage::Members::TamuraMeimi.new

        @members << Acme::Smileage::Members::MaedaYuuka.new
        @members << Acme::Smileage::Members::OgawaSaki.new
        @members << Acme::Smileage::Members::KosugaFuyuka.new

        @members.sort_by! {|e| [e.generation, e.birthday] }
      end

      def each(&block)
        @members.each(&block)
      end
    end
  end
end
