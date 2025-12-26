require 'ebay_trading/types/order'

module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  array_node :orders, 'OrderArray', 'Order', :class => Order, :default_value => []
    class GetOrderTransactions < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'GetOrderTransactionsResponse'
      array_node :orders, 'OrderArray', 'Order', :class => Order, :default_value => []
    end
  end
end


