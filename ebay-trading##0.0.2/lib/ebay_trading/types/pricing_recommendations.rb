require 'ebay_trading/types/product_info'

module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  object_node :product_info, 'ProductInfo', :class => ProductInfo, :optional => true
    class PricingRecommendations
      include XML::Mapping
      include Initializer
      root_element_name 'PricingRecommendations'
      object_node :product_info, 'ProductInfo', :class => ProductInfo, :optional => true
    end
  end
end


