require 'ebay_trading/types/context_search_asset'

module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  array_node :context_search_assets, 'ContextSearchAsset', :class => ContextSearchAsset, :default_value => []
    class GetContextualKeywords < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'GetContextualKeywordsResponse'
      array_node :context_search_assets, 'ContextSearchAsset', :class => ContextSearchAsset, :default_value => []
    end
  end
end


