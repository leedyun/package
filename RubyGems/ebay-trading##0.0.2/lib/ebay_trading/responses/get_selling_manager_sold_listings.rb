require 'ebay_trading/types/selling_manager_sold_order'
require 'ebay_trading/types/pagination_result'

module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  array_node :sale_records, 'SaleRecord', :class => SellingManagerSoldOrder, :default_value => []
    #  object_node :pagination_result, 'PaginationResult', :class => PaginationResult, :optional => true
    class GetSellingManagerSoldListings < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'GetSellingManagerSoldListingsResponse'
      array_node :sale_records, 'SaleRecord', :class => SellingManagerSoldOrder, :default_value => []
      object_node :pagination_result, 'PaginationResult', :class => PaginationResult, :optional => true
    end
  end
end


