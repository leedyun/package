
module EbayTrading # :nodoc:
  module Requests # :nodoc:
    # == Attributes
    #  datetime_node :start_time, 'StartTime', :optional => true
    #  datetime_node :end_time, 'EndTime', :optional => true
    #  text_node :item_id, 'ItemID', :optional => true
    class GetNotificationsUsage < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'GetNotificationsUsageRequest'
      datetime_node :start_time, 'StartTime', :optional => true
      datetime_node :end_time, 'EndTime', :optional => true
      text_node :item_id, 'ItemID', :optional => true
    end
  end
end


