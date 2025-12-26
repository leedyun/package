require 'ebay_trading/types/payment_transaction'

module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  array_node :payments, 'Payment', :class => PaymentTransaction, :default_value => []
    class PaymentInformation
      include XML::Mapping
      include Initializer
      root_element_name 'PaymentInformation'
      array_node :payments, 'Payment', :class => PaymentTransaction, :default_value => []
    end
  end
end


