require 'ebay_trading/types/selling_manager_product_details'

module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  object_node :deleted_selling_manager_product_details, 'DeletedSellingManagerProductDetails', :class => SellingManagerProductDetails, :optional => true
    class DeleteSellingManagerProduct < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'DeleteSellingManagerProductResponse'
      object_node :deleted_selling_manager_product_details, 'DeletedSellingManagerProductDetails', :class => SellingManagerProductDetails, :optional => true
    end
  end
end


