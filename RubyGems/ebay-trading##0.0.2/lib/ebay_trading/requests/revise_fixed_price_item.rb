require 'ebay_trading/types/item'

module EbayTrading # :nodoc:
  module Requests # :nodoc:
    # == Attributes
    #  object_node :item, 'Item', :class => Item, :optional => true
    #  text_node :deleted_field, 'DeletedField', :optional => true
    class ReviseFixedPriceItem < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'ReviseFixedPriceItemRequest'
      object_node :item, 'Item', :class => Item, :optional => true
      text_node :deleted_field, 'DeletedField', :optional => true
    end
  end
end


