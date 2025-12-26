require 'ebay_trading/types/item'
require 'ebay_trading/types/external_product_id'

module EbayTrading # :nodoc:
  module Requests # :nodoc:
    # == Attributes
    #  object_node :item, 'Item', :class => Item, :optional => true
    #  boolean_node :include_express_requirements, 'IncludeExpressRequirements', 'true', 'false', :optional => true
    #  object_node :external_product_id, 'ExternalProductID', :class => ExternalProductID, :optional => true
    class VerifyAddItem < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'VerifyAddItemRequest'
      object_node :item, 'Item', :class => Item, :optional => true
      boolean_node :include_express_requirements, 'IncludeExpressRequirements', 'true', 'false', :optional => true
      object_node :external_product_id, 'ExternalProductID', :class => ExternalProductID, :optional => true
    end
  end
end


