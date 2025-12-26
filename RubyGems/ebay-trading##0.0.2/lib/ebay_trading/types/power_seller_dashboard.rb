require 'ebay_trading/types/seller_dashboard_alert'

module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  text_node :level, 'Level', :optional => true
    #  array_node :alerts, 'Alert', :class => SellerDashboardAlert, :default_value => []
    class PowerSellerDashboard
      include XML::Mapping
      include Initializer
      root_element_name 'PowerSellerDashboard'
      text_node :level, 'Level', :optional => true
      array_node :alerts, 'Alert', :class => SellerDashboardAlert, :default_value => []
    end
  end
end


