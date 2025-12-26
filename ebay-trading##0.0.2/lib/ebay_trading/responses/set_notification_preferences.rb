
module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    class SetNotificationPreferences < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'SetNotificationPreferencesResponse'
    end
  end
end


