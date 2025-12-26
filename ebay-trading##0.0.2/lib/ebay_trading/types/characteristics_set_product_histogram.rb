require 'ebay_trading/types/histogram_entry'

module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  array_node :histogram_entries, 'HistogramEntry', :class => HistogramEntry, :default_value => []
    class CharacteristicsSetProductHistogram
      include XML::Mapping
      include Initializer
      root_element_name 'CharacteristicsSetProductHistogram'
      array_node :histogram_entries, 'HistogramEntry', :class => HistogramEntry, :default_value => []
    end
  end
end


