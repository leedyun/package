require 'ebay_trading/types/selling_manager_product'
require 'ebay_trading/types/pagination_result'

module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  datetime_node :inventory_count_last_calculated_date, 'InventoryCountLastCalculatedDate', :optional => true
    #  array_node :selling_manager_products, 'SellingManagerProduct', :class => SellingManagerProduct, :default_value => []
    #  object_node :pagination_result, 'PaginationResult', :class => PaginationResult, :optional => true
    class GetSellingManagerInventory < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'GetSellingManagerInventoryResponse'
      datetime_node :inventory_count_last_calculated_date, 'InventoryCountLastCalculatedDate', :optional => true
      array_node :selling_manager_products, 'SellingManagerProduct', :class => SellingManagerProduct, :default_value => []
      object_node :pagination_result, 'PaginationResult', :class => PaginationResult, :optional => true
    end
  end
end


