require 'ebay_trading/types/picture_manager_picture_display'

module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  text_node :picture_url, 'PictureURL', :optional => true
    #  text_node :name, 'Name', :optional => true
    #  datetime_node :date, 'Date', :optional => true
    #  array_node :display_formats, 'DisplayFormat', :class => PictureManagerPictureDisplay, :default_value => []
    class PictureManagerPicture
      include XML::Mapping
      include Initializer
      root_element_name 'PictureManagerPicture'
      text_node :picture_url, 'PictureURL', :optional => true
      text_node :name, 'Name', :optional => true
      datetime_node :date, 'Date', :optional => true
      array_node :display_formats, 'DisplayFormat', :class => PictureManagerPictureDisplay, :default_value => []
    end
  end
end


