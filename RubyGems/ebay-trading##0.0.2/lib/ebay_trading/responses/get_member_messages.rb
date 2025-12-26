require 'ebay_trading/types/member_message_exchange'
require 'ebay_trading/types/pagination_result'

module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  array_node :member_messages, 'MemberMessage', 'MemberMessageExchange', :class => MemberMessageExchange, :default_value => []
    #  object_node :pagination_result, 'PaginationResult', :class => PaginationResult, :optional => true
    #  boolean_node :has_more_items, 'HasMoreItems', 'true', 'false', :optional => true
    class GetMemberMessages < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'GetMemberMessagesResponse'
      array_node :member_messages, 'MemberMessage', 'MemberMessageExchange', :class => MemberMessageExchange, :default_value => []
      object_node :pagination_result, 'PaginationResult', :class => PaginationResult, :optional => true
      boolean_node :has_more_items, 'HasMoreItems', 'true', 'false', :optional => true
    end
  end
end


