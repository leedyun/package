require 'ebay_trading/types/vero_report_item'

module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  array_node :report_items, 'ReportItem', :class => VeROReportItem, :default_value => []
    class VeROReportItems
      include XML::Mapping
      include Initializer
      root_element_name 'VeROReportItems'
      array_node :report_items, 'ReportItem', :class => VeROReportItem, :default_value => []
    end
  end
end


