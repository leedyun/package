require 'ebay_trading/types/best_offer'

module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  array_node :respond_to_best_offers, 'RespondToBestOffer', 'BestOffer', :class => BestOffer, :default_value => []
    class RespondToBestOffer < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'RespondToBestOfferResponse'
      array_node :respond_to_best_offers, 'RespondToBestOffer', 'BestOffer', :class => BestOffer, :default_value => []
    end
  end
end


