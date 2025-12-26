require 'ebay_trading/types/store_theme'
require 'ebay_trading/types/store_color_scheme'

module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  array_node :themes, 'Theme', :class => StoreTheme, :default_value => []
    #  array_node :generic_color_schemes, 'GenericColorSchemeArray', 'ColorScheme', :class => StoreColorScheme, :default_value => []
    class StoreThemeArray
      include XML::Mapping
      include Initializer
      root_element_name 'StoreThemeArray'
      array_node :themes, 'Theme', :class => StoreTheme, :default_value => []
      array_node :generic_color_schemes, 'GenericColorSchemeArray', 'ColorScheme', :class => StoreColorScheme, :default_value => []
    end
  end
end


