require 'ebay_trading/types/vero_report_item'

module EbayTrading # :nodoc:
  module Requests # :nodoc:
    # == Attributes
    #  text_node :rights_owner_id, 'RightsOwnerID', :optional => true
    #  array_node :report_items, 'ReportItems', 'ReportItem', :class => VeROReportItem, :default_value => []
    class VeROReportItems < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'VeROReportItemsRequest'
      text_node :rights_owner_id, 'RightsOwnerID', :optional => true
      array_node :report_items, 'ReportItems', 'ReportItem', :class => VeROReportItem, :default_value => []
    end
  end
end


