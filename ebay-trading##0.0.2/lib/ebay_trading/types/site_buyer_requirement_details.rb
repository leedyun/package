require 'ebay_trading/types/maximum_buyer_policy_violations_details'
require 'ebay_trading/types/maximum_item_requirements_details'
require 'ebay_trading/types/maximum_unpaid_item_strikes_info_details'
require 'ebay_trading/types/minimum_feedback_score_details'
require 'ebay_trading/types/verified_user_requirements_details'

module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  boolean_node :linked_paypal_account, 'LinkedPayPalAccount', 'true', 'false', :optional => true
    #  object_node :maximum_buyer_policy_violations, 'MaximumBuyerPolicyViolations', :class => MaximumBuyerPolicyViolationsDetails, :optional => true
    #  object_node :maximum_item_requirements, 'MaximumItemRequirements', :class => MaximumItemRequirementsDetails, :optional => true
    #  object_node :maximum_unpaid_item_strikes_info, 'MaximumUnpaidItemStrikesInfo', :class => MaximumUnpaidItemStrikesInfoDetails, :optional => true
    #  array_node :minimum_feedback_scores, 'MinimumFeedbackScore', :class => MinimumFeedbackScoreDetails, :default_value => []
    #  boolean_node :ship_to_registration_country, 'ShipToRegistrationCountry', 'true', 'false', :optional => true
    #  object_node :verified_user_requirements, 'VerifiedUserRequirements', :class => VerifiedUserRequirementsDetails, :optional => true
    #  text_node :detail_version, 'DetailVersion', :optional => true
    #  datetime_node :update_time, 'UpdateTime', :optional => true
    class SiteBuyerRequirementDetails
      include XML::Mapping
      include Initializer
      root_element_name 'SiteBuyerRequirementDetails'
      boolean_node :linked_paypal_account, 'LinkedPayPalAccount', 'true', 'false', :optional => true
      object_node :maximum_buyer_policy_violations, 'MaximumBuyerPolicyViolations', :class => MaximumBuyerPolicyViolationsDetails, :optional => true
      object_node :maximum_item_requirements, 'MaximumItemRequirements', :class => MaximumItemRequirementsDetails, :optional => true
      object_node :maximum_unpaid_item_strikes_info, 'MaximumUnpaidItemStrikesInfo', :class => MaximumUnpaidItemStrikesInfoDetails, :optional => true
      array_node :minimum_feedback_scores, 'MinimumFeedbackScore', :class => MinimumFeedbackScoreDetails, :default_value => []
      boolean_node :ship_to_registration_country, 'ShipToRegistrationCountry', 'true', 'false', :optional => true
      object_node :verified_user_requirements, 'VerifiedUserRequirements', :class => VerifiedUserRequirementsDetails, :optional => true
      text_node :detail_version, 'DetailVersion', :optional => true
      datetime_node :update_time, 'UpdateTime', :optional => true
    end
  end
end


