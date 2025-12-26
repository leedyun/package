
module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  text_node :item_id, 'ItemID', :optional => true
    #  datetime_node :start_time, 'StartTime', :optional => true
    #  datetime_node :end_time, 'EndTime', :optional => true
    class AddSecondChanceItem < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'AddSecondChanceItemResponse'
      text_node :item_id, 'ItemID', :optional => true
      datetime_node :start_time, 'StartTime', :optional => true
      datetime_node :end_time, 'EndTime', :optional => true
    end
  end
end


