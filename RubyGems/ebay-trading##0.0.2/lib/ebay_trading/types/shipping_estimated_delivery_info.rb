
module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  datetime_node :original_delivery_estimated_time_min, 'OriginalDeliveryEstimatedTimeMin', :optional => true
    #  datetime_node :original_delivery_estimated_time_max, 'OriginalDeliveryEstimatedTimeMax', :optional => true
    class ShippingEstimatedDeliveryInfo
      include XML::Mapping
      include Initializer
      root_element_name 'ShippingEstimatedDeliveryInfo'
      datetime_node :original_delivery_estimated_time_min, 'OriginalDeliveryEstimatedTimeMin', :optional => true
      datetime_node :original_delivery_estimated_time_max, 'OriginalDeliveryEstimatedTimeMax', :optional => true
    end
  end
end


