require 'ebay_trading/types/payment_transaction_code'

module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  array_node :payments, 'Payment', :class => PaymentTransactionCode, :default_value => []
    class PaymentInformationCode
      include XML::Mapping
      include Initializer
      root_element_name 'PaymentInformationCode'
      array_node :payments, 'Payment', :class => PaymentTransactionCode, :default_value => []
    end
  end
end


