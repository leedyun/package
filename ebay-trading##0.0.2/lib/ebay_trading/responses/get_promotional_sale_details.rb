require 'ebay_trading/types/promotional_sale'

module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  array_node :promotional_sale_details, 'PromotionalSaleDetails', 'PromotionalSale', :class => PromotionalSale, :default_value => []
    class GetPromotionalSaleDetails < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'GetPromotionalSaleDetailsResponse'
      array_node :promotional_sale_details, 'PromotionalSaleDetails', 'PromotionalSale', :class => PromotionalSale, :default_value => []
    end
  end
end


