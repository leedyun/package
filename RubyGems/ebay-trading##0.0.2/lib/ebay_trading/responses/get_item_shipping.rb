require 'ebay_trading/types/shipping_details'
require 'ebay_trading/types/pickup_in_store_details'

module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  object_node :shipping_details, 'ShippingDetails', :class => ShippingDetails, :optional => true
    #  object_node :pick_up_in_store_details, 'PickUpInStoreDetails', :class => PickupInStoreDetails, :optional => true
    class GetItemShipping < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'GetItemShippingResponse'
      object_node :shipping_details, 'ShippingDetails', :class => ShippingDetails, :optional => true
      object_node :pick_up_in_store_details, 'PickUpInStoreDetails', :class => PickupInStoreDetails, :optional => true
    end
  end
end


