require 'ebay_trading/types/selling_manager_product_details'

module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  object_node :selling_manager_product_details, 'SellingManagerProductDetails', :class => SellingManagerProductDetails, :optional => true
    class AddSellingManagerProduct < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'AddSellingManagerProductResponse'
      object_node :selling_manager_product_details, 'SellingManagerProductDetails', :class => SellingManagerProductDetails, :optional => true
    end
  end
end


