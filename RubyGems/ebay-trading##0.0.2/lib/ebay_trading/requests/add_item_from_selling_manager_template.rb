require 'ebay_trading/types/item'

module EbayTrading # :nodoc:
  module Requests # :nodoc:
    # == Attributes
    #  numeric_node :sale_template_id, 'SaleTemplateID', :optional => true
    #  datetime_node :schedule_time, 'ScheduleTime', :optional => true
    #  object_node :item, 'Item', :class => Item, :optional => true
    class AddItemFromSellingManagerTemplate < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'AddItemFromSellingManagerTemplateRequest'
      numeric_node :sale_template_id, 'SaleTemplateID', :optional => true
      datetime_node :schedule_time, 'ScheduleTime', :optional => true
      object_node :item, 'Item', :class => Item, :optional => true
    end
  end
end


