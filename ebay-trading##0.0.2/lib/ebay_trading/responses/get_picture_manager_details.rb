require 'ebay_trading/types/picture_manager_details'

module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  object_node :picture_manager_details, 'PictureManagerDetails', :class => PictureManagerDetails, :optional => true
    class GetPictureManagerDetails < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'GetPictureManagerDetailsResponse'
      object_node :picture_manager_details, 'PictureManagerDetails', :class => PictureManagerDetails, :optional => true
    end
  end
end


