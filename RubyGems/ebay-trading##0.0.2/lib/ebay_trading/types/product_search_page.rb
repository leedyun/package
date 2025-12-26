require 'ebay_trading/types/characteristics_set'
require 'ebay_trading/types/characteristic'
require 'ebay_trading/types/data_element_set'

module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  object_node :search_characteristics_set, 'SearchCharacteristicsSet', :class => CharacteristicsSet, :optional => true
    #  text_node :search_type, 'SearchType', :optional => true
    #  array_node :sort_characteristics, 'SortCharacteristics', :class => Characteristic, :default_value => []
    #  array_node :data_element_sets, 'DataElementSet', :class => DataElementSet, :default_value => []
    class ProductSearchPage
      include XML::Mapping
      include Initializer
      root_element_name 'ProductSearchPage'
      object_node :search_characteristics_set, 'SearchCharacteristicsSet', :class => CharacteristicsSet, :optional => true
      text_node :search_type, 'SearchType', :optional => true
      array_node :sort_characteristics, 'SortCharacteristics', :class => Characteristic, :default_value => []
      array_node :data_element_sets, 'DataElementSet', :class => DataElementSet, :default_value => []
    end
  end
end


