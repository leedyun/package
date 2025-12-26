require 'ebay_trading/types/user'
require 'ebay_trading/types/shipping_details'
require 'ebay_trading/types/item'
require 'ebay_trading/types/transaction_status'
require 'ebay_trading/types/external_transaction'
require 'ebay_trading/types/selling_manager_product_details'
require 'ebay_trading/types/shipping_service_options'
require 'ebay_trading/types/feedback_info'
require 'ebay_trading/types/order'
require 'ebay_trading/types/listing_checkout_redirect_preference'
require 'ebay_trading/types/refund'
require 'ebay_trading/types/variation'
require 'ebay_trading/types/taxes'
require 'ebay_trading/types/payment_hold_detail'
require 'ebay_trading/types/seller_discounts'
require 'ebay_trading/types/multi_leg_shipping_details'
require 'ebay_trading/types/unpaid_item'
require 'ebay_trading/types/payments_information'
require 'ebay_trading/types/pickup_options'
require 'ebay_trading/types/pickup_method_selected'
require 'ebay_trading/types/buyer_package_enclosure'

module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  money_node :amount_paid, 'AmountPaid', :optional => true
    #  money_node :adjustment_amount, 'AdjustmentAmount', :optional => true
    #  money_node :converted_adjustment_amount, 'ConvertedAdjustmentAmount', :optional => true
    #  object_node :buyer, 'Buyer', :class => User, :optional => true
    #  object_node :shipping_details, 'ShippingDetails', :class => ShippingDetails, :optional => true
    #  money_node :converted_amount_paid, 'ConvertedAmountPaid', :optional => true
    #  money_node :converted_transaction_price, 'ConvertedTransactionPrice', :optional => true
    #  datetime_node :created_date, 'CreatedDate', :optional => true
    #  text_node :deposit_type, 'DepositType', :optional => true
    #  object_node :item, 'Item', :class => Item, :optional => true
    #  numeric_node :quantity_purchased, 'QuantityPurchased', :optional => true
    #  object_node :status, 'Status', :class => TransactionStatus, :optional => true
    #  text_node :transaction_id, 'TransactionID', :optional => true
    #  money_node :transaction_price, 'TransactionPrice', :optional => true
    #  boolean_node :best_offer_sale, 'BestOfferSale', 'true', 'false', :optional => true
    #  numeric_node :vat_percent, 'VATPercent', :optional => true
    #  array_node :external_transactions, 'ExternalTransaction', :class => ExternalTransaction, :default_value => []
    #  object_node :selling_manager_product_details, 'SellingManagerProductDetails', :class => SellingManagerProductDetails, :optional => true
    #  object_node :shipping_service_selected, 'ShippingServiceSelected', :class => ShippingServiceOptions, :optional => true
    #  text_node :buyer_message, 'BuyerMessage', :optional => true
    #  money_node :dutch_auction_bid, 'DutchAuctionBid', :optional => true
    #  text_node :buyer_paid_status, 'BuyerPaidStatus', :optional => true
    #  text_node :seller_paid_status, 'SellerPaidStatus', :optional => true
    #  datetime_node :paid_time, 'PaidTime', :optional => true
    #  datetime_node :shipped_time, 'ShippedTime', :optional => true
    #  money_node :total_price, 'TotalPrice', :optional => true
    #  object_node :feedback_left, 'FeedbackLeft', :class => FeedbackInfo, :optional => true
    #  object_node :feedback_received, 'FeedbackReceived', :class => FeedbackInfo, :optional => true
    #  object_node :containing_order, 'ContainingOrder', :class => Order, :optional => true
    #  money_node :final_value_fee, 'FinalValueFee', :optional => true
    #  object_node :listing_checkout_redirect_preference, 'ListingCheckoutRedirectPreference', :class => ListingCheckoutRedirectPreference, :optional => true
    #  array_node :refunds, 'RefundArray', 'Refund', :class => Refund, :default_value => []
    #  text_node :transaction_site_id, 'TransactionSiteID', :optional => true
    #  text_node :platform, 'Platform', :optional => true
    #  text_node :cart_id, 'CartID', :optional => true
    #  boolean_node :seller_contact_buyer_by_email, 'SellerContactBuyerByEmail', 'true', 'false', :optional => true
    #  text_node :paypal_email_address, 'PayPalEmailAddress', :optional => true
    #  text_node :paisa_pay_id, 'PaisaPayID', :optional => true
    #  money_node :buyer_guarantee_price, 'BuyerGuaranteePrice', :optional => true
    #  object_node :variation, 'Variation', :class => Variation, :optional => true
    #  text_node :buyer_checkout_message, 'BuyerCheckoutMessage', :optional => true
    #  object_node :taxes, 'Taxes', :class => Taxes, :optional => true
    #  boolean_node :bundle_purchase, 'BundlePurchase', 'true', 'false', :optional => true
    #  money_node :actual_shipping_cost, 'ActualShippingCost', :optional => true
    #  money_node :actual_handling_cost, 'ActualHandlingCost', :optional => true
    #  text_node :order_line_item_id, 'OrderLineItemID', :optional => true
    #  object_node :payment_hold_details, 'PaymentHoldDetails', :class => PaymentHoldDetail, :optional => true
    #  object_node :seller_discounts, 'SellerDiscounts', :class => SellerDiscounts, :optional => true
    #  money_node :refund_amount, 'RefundAmount', :optional => true
    #  text_node :refund_status, 'RefundStatus', :optional => true
    #  text_node :codice_fiscale, 'CodiceFiscale', :optional => true
    #  boolean_node :is_multi_leg_shipping, 'IsMultiLegShipping', 'true', 'false', :optional => true
    #  object_node :multi_leg_shipping_details, 'MultiLegShippingDetails', :class => MultiLegShippingDetails, :optional => true
    #  datetime_node :invoice_sent_time, 'InvoiceSentTime', :optional => true
    #  object_node :unpaid_item, 'UnpaidItem', :class => UnpaidItem, :optional => true
    #  boolean_node :intangible_item, 'IntangibleItem', 'true', 'false', :optional => true
    #  object_node :monetary_details, 'MonetaryDetails', :class => PaymentsInformation, :optional => true
    #  array_node :pickup_details, 'PickupDetails', 'PickupOptions', :class => PickupOptions, :default_value => []
    #  object_node :pickup_method_selected, 'PickupMethodSelected', :class => PickupMethodSelected, :optional => true
    #  money_node :shipping_convenience_charge, 'ShippingConvenienceCharge', :optional => true
    #  text_node :logistics_plan_type, 'LogisticsPlanType', :optional => true
    #  array_node :buyer_package_enclosures, 'BuyerPackageEnclosures', 'BuyerPackageEnclosure', :class => BuyerPackageEnclosure, :default_value => []
    #  text_node :inventory_reservation_id, 'InventoryReservationID', :optional => true
    #  text_node :extended_order_id, 'ExtendedOrderID', :optional => true
    #  boolean_node :ebay_plus_transaction, 'eBayPlusTransaction', 'true', 'false', :optional => true
    class Transaction
      include XML::Mapping
      include Initializer
      root_element_name 'Transaction'
      money_node :amount_paid, 'AmountPaid', :optional => true
      money_node :adjustment_amount, 'AdjustmentAmount', :optional => true
      money_node :converted_adjustment_amount, 'ConvertedAdjustmentAmount', :optional => true
      object_node :buyer, 'Buyer', :class => User, :optional => true
      object_node :shipping_details, 'ShippingDetails', :class => ShippingDetails, :optional => true
      money_node :converted_amount_paid, 'ConvertedAmountPaid', :optional => true
      money_node :converted_transaction_price, 'ConvertedTransactionPrice', :optional => true
      datetime_node :created_date, 'CreatedDate', :optional => true
      text_node :deposit_type, 'DepositType', :optional => true
      object_node :item, 'Item', :class => Item, :optional => true
      numeric_node :quantity_purchased, 'QuantityPurchased', :optional => true
      object_node :status, 'Status', :class => TransactionStatus, :optional => true
      text_node :transaction_id, 'TransactionID', :optional => true
      money_node :transaction_price, 'TransactionPrice', :optional => true
      boolean_node :best_offer_sale, 'BestOfferSale', 'true', 'false', :optional => true
      numeric_node :vat_percent, 'VATPercent', :optional => true
      array_node :external_transactions, 'ExternalTransaction', :class => ExternalTransaction, :default_value => []
      object_node :selling_manager_product_details, 'SellingManagerProductDetails', :class => SellingManagerProductDetails, :optional => true
      object_node :shipping_service_selected, 'ShippingServiceSelected', :class => ShippingServiceOptions, :optional => true
      text_node :buyer_message, 'BuyerMessage', :optional => true
      money_node :dutch_auction_bid, 'DutchAuctionBid', :optional => true
      text_node :buyer_paid_status, 'BuyerPaidStatus', :optional => true
      text_node :seller_paid_status, 'SellerPaidStatus', :optional => true
      datetime_node :paid_time, 'PaidTime', :optional => true
      datetime_node :shipped_time, 'ShippedTime', :optional => true
      money_node :total_price, 'TotalPrice', :optional => true
      object_node :feedback_left, 'FeedbackLeft', :class => FeedbackInfo, :optional => true
      object_node :feedback_received, 'FeedbackReceived', :class => FeedbackInfo, :optional => true
      object_node :containing_order, 'ContainingOrder', :class => Order, :optional => true
      money_node :final_value_fee, 'FinalValueFee', :optional => true
      object_node :listing_checkout_redirect_preference, 'ListingCheckoutRedirectPreference', :class => ListingCheckoutRedirectPreference, :optional => true
      array_node :refunds, 'RefundArray', 'Refund', :class => Refund, :default_value => []
      text_node :transaction_site_id, 'TransactionSiteID', :optional => true
      text_node :platform, 'Platform', :optional => true
      text_node :cart_id, 'CartID', :optional => true
      boolean_node :seller_contact_buyer_by_email, 'SellerContactBuyerByEmail', 'true', 'false', :optional => true
      text_node :paypal_email_address, 'PayPalEmailAddress', :optional => true
      text_node :paisa_pay_id, 'PaisaPayID', :optional => true
      money_node :buyer_guarantee_price, 'BuyerGuaranteePrice', :optional => true
      object_node :variation, 'Variation', :class => Variation, :optional => true
      text_node :buyer_checkout_message, 'BuyerCheckoutMessage', :optional => true
      object_node :taxes, 'Taxes', :class => Taxes, :optional => true
      boolean_node :bundle_purchase, 'BundlePurchase', 'true', 'false', :optional => true
      money_node :actual_shipping_cost, 'ActualShippingCost', :optional => true
      money_node :actual_handling_cost, 'ActualHandlingCost', :optional => true
      text_node :order_line_item_id, 'OrderLineItemID', :optional => true
      object_node :payment_hold_details, 'PaymentHoldDetails', :class => PaymentHoldDetail, :optional => true
      object_node :seller_discounts, 'SellerDiscounts', :class => SellerDiscounts, :optional => true
      money_node :refund_amount, 'RefundAmount', :optional => true
      text_node :refund_status, 'RefundStatus', :optional => true
      text_node :codice_fiscale, 'CodiceFiscale', :optional => true
      boolean_node :is_multi_leg_shipping, 'IsMultiLegShipping', 'true', 'false', :optional => true
      object_node :multi_leg_shipping_details, 'MultiLegShippingDetails', :class => MultiLegShippingDetails, :optional => true
      datetime_node :invoice_sent_time, 'InvoiceSentTime', :optional => true
      object_node :unpaid_item, 'UnpaidItem', :class => UnpaidItem, :optional => true
      boolean_node :intangible_item, 'IntangibleItem', 'true', 'false', :optional => true
      object_node :monetary_details, 'MonetaryDetails', :class => PaymentsInformation, :optional => true
      array_node :pickup_details, 'PickupDetails', 'PickupOptions', :class => PickupOptions, :default_value => []
      object_node :pickup_method_selected, 'PickupMethodSelected', :class => PickupMethodSelected, :optional => true
      money_node :shipping_convenience_charge, 'ShippingConvenienceCharge', :optional => true
      text_node :logistics_plan_type, 'LogisticsPlanType', :optional => true
      array_node :buyer_package_enclosures, 'BuyerPackageEnclosures', 'BuyerPackageEnclosure', :class => BuyerPackageEnclosure, :default_value => []
      text_node :inventory_reservation_id, 'InventoryReservationID', :optional => true
      text_node :extended_order_id, 'ExtendedOrderID', :optional => true
      boolean_node :ebay_plus_transaction, 'eBayPlusTransaction', 'true', 'false', :optional => true
    end
  end
end


