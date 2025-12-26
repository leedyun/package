require 'ebay_trading/types/cross_promotions'

module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  object_node :cross_promotion, 'CrossPromotion', :class => CrossPromotions, :optional => true
    class GetCrossPromotions < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'GetCrossPromotionsResponse'
      object_node :cross_promotion, 'CrossPromotion', :class => CrossPromotions, :optional => true
    end
  end
end


