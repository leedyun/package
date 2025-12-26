
module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  datetime_node :end_time, 'EndTime', :optional => true
    class EndItem < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'EndItemResponse'
      datetime_node :end_time, 'EndTime', :optional => true
    end
  end
end


