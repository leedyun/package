
module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    class RevokeToken < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'RevokeTokenResponse'
    end
  end
end


