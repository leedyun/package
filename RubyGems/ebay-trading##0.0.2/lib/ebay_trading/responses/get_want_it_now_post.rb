require 'ebay_trading/types/want_it_now_post'

module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  object_node :want_it_now_post, 'WantItNowPost', :class => WantItNowPost, :optional => true
    class GetWantItNowPost < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'GetWantItNowPostResponse'
      object_node :want_it_now_post, 'WantItNowPost', :class => WantItNowPost, :optional => true
    end
  end
end


