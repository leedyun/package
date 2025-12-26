
module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  money_node :original_price, 'OriginalPrice', :optional => true
    #  datetime_node :start_time, 'StartTime', :optional => true
    #  datetime_node :end_time, 'EndTime', :optional => true
    class PromotionalSaleDetails
      include XML::Mapping
      include Initializer
      root_element_name 'PromotionalSaleDetails'
      money_node :original_price, 'OriginalPrice', :optional => true
      datetime_node :start_time, 'StartTime', :optional => true
      datetime_node :end_time, 'EndTime', :optional => true
    end
  end
end


