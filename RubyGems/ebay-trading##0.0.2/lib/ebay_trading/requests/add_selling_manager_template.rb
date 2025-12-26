require 'ebay_trading/types/item'

module EbayTrading # :nodoc:
  module Requests # :nodoc:
    # == Attributes
    #  object_node :item, 'Item', :class => Item, :optional => true
    #  text_node :sale_template_name, 'SaleTemplateName', :optional => true
    #  numeric_node :product_id, 'ProductID', :optional => true
    class AddSellingManagerTemplate < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'AddSellingManagerTemplateRequest'
      object_node :item, 'Item', :class => Item, :optional => true
      text_node :sale_template_name, 'SaleTemplateName', :optional => true
      numeric_node :product_id, 'ProductID', :optional => true
    end
  end
end


