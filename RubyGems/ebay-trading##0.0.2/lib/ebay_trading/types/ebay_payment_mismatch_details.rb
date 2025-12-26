
module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  text_node :mismatch_type, 'MismatchType', :optional => true
    #  datetime_node :action_required_by, 'ActionRequiredBy', :optional => true
    #  money_node :mismatch_amount, 'MismatchAmount', :optional => true
    class EBayPaymentMismatchDetails
      include XML::Mapping
      include Initializer
      root_element_name 'EBayPaymentMismatchDetails'
      text_node :mismatch_type, 'MismatchType', :optional => true
      datetime_node :action_required_by, 'ActionRequiredBy', :optional => true
      money_node :mismatch_amount, 'MismatchAmount', :optional => true
    end
  end
end


