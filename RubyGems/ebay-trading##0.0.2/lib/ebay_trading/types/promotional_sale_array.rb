require 'ebay_trading/types/promotional_sale'

module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  array_node :promotional_sales, 'PromotionalSale', :class => PromotionalSale, :default_value => []
    class PromotionalSaleArray
      include XML::Mapping
      include Initializer
      root_element_name 'PromotionalSaleArray'
      array_node :promotional_sales, 'PromotionalSale', :class => PromotionalSale, :default_value => []
    end
  end
end


