
module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  datetime_node :time_from, 'TimeFrom', :optional => true
    #  datetime_node :time_to, 'TimeTo', :optional => true
    class TimeRange
      include XML::Mapping
      include Initializer
      root_element_name 'TimeRange'
      datetime_node :time_from, 'TimeFrom', :optional => true
      datetime_node :time_to, 'TimeTo', :optional => true
    end
  end
end


