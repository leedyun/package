require 'ebay_trading/types/selling_manager_folder_details'

module EbayTrading # :nodoc:
  module Requests # :nodoc:
    # == Attributes
    #  object_node :folder, 'Folder', :class => SellingManagerFolderDetails, :optional => true
    class ReviseSellingManagerInventoryFolder < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'ReviseSellingManagerInventoryFolderRequest'
      object_node :folder, 'Folder', :class => SellingManagerFolderDetails, :optional => true
    end
  end
end


