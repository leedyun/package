require 'ebay_trading/types/tax_jurisdiction'

module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  datetime_node :last_update_time, 'LastUpdateTime', :optional => true
    #  array_node :tax_tables, 'TaxTable', 'TaxJurisdiction', :class => TaxJurisdiction, :default_value => []
    class GetTaxTable < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'GetTaxTableResponse'
      datetime_node :last_update_time, 'LastUpdateTime', :optional => true
      array_node :tax_tables, 'TaxTable', 'TaxJurisdiction', :class => TaxJurisdiction, :default_value => []
    end
  end
end


