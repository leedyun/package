require 'ebay_trading/types/item'
require 'ebay_trading/types/pagination_result'

module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  array_node :items, 'ItemArray', 'Item', :class => Item, :default_value => []
    #  object_node :pagination_result, 'PaginationResult', :class => PaginationResult, :optional => true
    class PaginatedItemArray
      include XML::Mapping
      include Initializer
      root_element_name 'PaginatedItemArray'
      array_node :items, 'ItemArray', 'Item', :class => Item, :default_value => []
      object_node :pagination_result, 'PaginationResult', :class => PaginationResult, :optional => true
    end
  end
end


