require 'ebay_trading/types/member_message'

module EbayTrading # :nodoc:
  module Requests # :nodoc:
    # == Attributes
    #  text_node :item_id, 'ItemID', :optional => true
    #  object_node :member_message, 'MemberMessage', :class => MemberMessage, :optional => true
    class AddMemberMessageRTQ < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'AddMemberMessageRTQRequest'
      text_node :item_id, 'ItemID', :optional => true
      object_node :member_message, 'MemberMessage', :class => MemberMessage, :optional => true
    end
  end
end


