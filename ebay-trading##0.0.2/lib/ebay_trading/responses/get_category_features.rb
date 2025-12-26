require 'ebay_trading/types/category_feature'
require 'ebay_trading/types/site_defaults'
require 'ebay_trading/types/feature_definitions'

module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  text_node :category_version, 'CategoryVersion', :optional => true
    #  datetime_node :update_time, 'UpdateTime', :optional => true
    #  array_node :categories, 'Category', :class => CategoryFeature, :default_value => []
    #  object_node :site_defaults, 'SiteDefaults', :class => SiteDefaults, :optional => true
    #  object_node :feature_definitions, 'FeatureDefinitions', :class => FeatureDefinitions, :optional => true
    class GetCategoryFeatures < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'GetCategoryFeaturesResponse'
      text_node :category_version, 'CategoryVersion', :optional => true
      datetime_node :update_time, 'UpdateTime', :optional => true
      array_node :categories, 'Category', :class => CategoryFeature, :default_value => []
      object_node :site_defaults, 'SiteDefaults', :class => SiteDefaults, :optional => true
      object_node :feature_definitions, 'FeatureDefinitions', :class => FeatureDefinitions, :optional => true
    end
  end
end


