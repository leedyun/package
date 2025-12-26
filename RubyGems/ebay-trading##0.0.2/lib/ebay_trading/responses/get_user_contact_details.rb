require 'ebay_trading/types/address'

module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    #  text_node :user_id, 'UserID', :optional => true
    #  object_node :contact_address, 'ContactAddress', :class => Address, :optional => true
    #  datetime_node :registration_date, 'RegistrationDate', :optional => true
    class GetUserContactDetails < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'GetUserContactDetailsResponse'
      text_node :user_id, 'UserID', :optional => true
      object_node :contact_address, 'ContactAddress', :class => Address, :optional => true
      datetime_node :registration_date, 'RegistrationDate', :optional => true
    end
  end
end


