require 'ebay_trading/types/address'
require 'ebay_trading/types/tax_identifier'

module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  object_node :shipping_address, 'ShippingAddress', :class => Address, :optional => true
    #  array_node :buyer_tax_identifiers, 'BuyerTaxIdentifier', :class => TaxIdentifier, :default_value => []
    class Buyer
      include XML::Mapping
      include Initializer
      root_element_name 'Buyer'
      object_node :shipping_address, 'ShippingAddress', :class => Address, :optional => true
      array_node :buyer_tax_identifiers, 'BuyerTaxIdentifier', :class => TaxIdentifier, :default_value => []
    end
  end
end


