require 'ebay_trading/types/promotional_sale'

module EbayTrading # :nodoc:
  module Requests # :nodoc:
    # == Attributes
    #  text_node :action, 'Action', :optional => true
    #  object_node :promotional_sale_details, 'PromotionalSaleDetails', :class => PromotionalSale, :optional => true
    class SetPromotionalSale < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'SetPromotionalSaleRequest'
      text_node :action, 'Action', :optional => true
      object_node :promotional_sale_details, 'PromotionalSaleDetails', :class => PromotionalSale, :optional => true
    end
  end
end


