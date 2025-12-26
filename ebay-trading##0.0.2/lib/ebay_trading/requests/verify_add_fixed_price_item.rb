require 'ebay_trading/types/item'

module EbayTrading # :nodoc:
  module Requests # :nodoc:
    # == Attributes
    #  object_node :item, 'Item', :class => Item, :optional => true
    class VerifyAddFixedPriceItem < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'VerifyAddFixedPriceItemRequest'
      object_node :item, 'Item', :class => Item, :optional => true
    end
  end
end


