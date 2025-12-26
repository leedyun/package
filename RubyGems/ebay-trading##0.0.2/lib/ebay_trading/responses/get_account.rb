require 'ebay_trading/types/account_summary'
require 'ebay_trading/types/account_entry'
require 'ebay_trading/types/pagination_result'

module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  text_node :account_id, 'AccountID', :optional => true
    #  object_node :account_summary, 'AccountSummary', :class => AccountSummary, :optional => true
    #  text_node :currency, 'Currency', :optional => true
    #  array_node :account_entries, 'AccountEntries', 'AccountEntry', :class => AccountEntry, :default_value => []
    #  object_node :pagination_result, 'PaginationResult', :class => PaginationResult, :optional => true
    #  boolean_node :has_more_entries, 'HasMoreEntries', 'true', 'false', :optional => true
    #  numeric_node :entries_per_page, 'EntriesPerPage', :optional => true
    #  numeric_node :page_number, 'PageNumber', :optional => true
    class GetAccount < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'GetAccountResponse'
      text_node :account_id, 'AccountID', :optional => true
      object_node :account_summary, 'AccountSummary', :class => AccountSummary, :optional => true
      text_node :currency, 'Currency', :optional => true
      array_node :account_entries, 'AccountEntries', 'AccountEntry', :class => AccountEntry, :default_value => []
      object_node :pagination_result, 'PaginationResult', :class => PaginationResult, :optional => true
      boolean_node :has_more_entries, 'HasMoreEntries', 'true', 'false', :optional => true
      numeric_node :entries_per_page, 'EntriesPerPage', :optional => true
      numeric_node :page_number, 'PageNumber', :optional => true
    end
  end
end


