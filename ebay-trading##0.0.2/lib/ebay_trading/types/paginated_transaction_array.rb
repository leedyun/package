require 'ebay_trading/types/transaction'
require 'ebay_trading/types/pagination_result'

module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  array_node :transactions, 'TransactionArray', 'Transaction', :class => Transaction, :default_value => []
    #  object_node :pagination_result, 'PaginationResult', :class => PaginationResult, :optional => true
    class PaginatedTransactionArray
      include XML::Mapping
      include Initializer
      root_element_name 'PaginatedTransactionArray'
      array_node :transactions, 'TransactionArray', 'Transaction', :class => Transaction, :default_value => []
      object_node :pagination_result, 'PaginationResult', :class => PaginationResult, :optional => true
    end
  end
end


