
module EbayTrading # :nodoc:
  module Responses # :nodoc:
    # == Attributes
    class SendInvoice < Abstract
      include XML::Mapping
      include Initializer
      root_element_name 'SendInvoiceResponse'
    end
  end
end


