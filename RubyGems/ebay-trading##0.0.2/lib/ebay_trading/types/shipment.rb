require 'ebay_trading/types/measure'
require 'ebay_trading/types/address'
require 'ebay_trading/types/item_transaction_id'
require 'ebay_trading/types/shipment_tracking_details'
require 'ebay_trading/types/line_item'

module EbayTrading # :nodoc:
  module Types # :nodoc:
    # == Attributes
    #  datetime_node :estimated_delivery_date, 'EstimatedDeliveryDate', :optional => true
    #  money_node :insured_value, 'InsuredValue', :optional => true
    #  object_node :package_depth, 'PackageDepth', :class => Measure, :optional => true
    #  object_node :package_length, 'PackageLength', :class => Measure, :optional => true
    #  object_node :package_width, 'PackageWidth', :class => Measure, :optional => true
    #  text_node :paypal_shipment_id, 'PayPalShipmentID', :optional => true
    #  numeric_node :shipment_id, 'ShipmentID', :optional => true
    #  money_node :postage_total, 'PostageTotal', :optional => true
    #  datetime_node :printed_time, 'PrintedTime', :optional => true
    #  object_node :ship_from_address, 'ShipFromAddress', :class => Address, :optional => true
    #  object_node :shipping_address, 'ShippingAddress', :class => Address, :optional => true
    #  text_node :shipping_carrier_used, 'ShippingCarrierUsed', :optional => true
    #  value_array_node :shipping_features, 'ShippingFeature', :default_value => []
    #  text_node :shipping_package, 'ShippingPackage', :optional => true
    #  text_node :shipping_service_used, 'ShippingServiceUsed', :optional => true
    #  text_node :shipment_tracking_number, 'ShipmentTrackingNumber', :optional => true
    #  object_node :weight_major, 'WeightMajor', :class => Measure, :optional => true
    #  object_node :weight_minor, 'WeightMinor', :class => Measure, :optional => true
    #  array_node :item_transaction_ids, 'ItemTransactionID', :class => ItemTransactionID, :default_value => []
    #  datetime_node :delivery_date, 'DeliveryDate', :optional => true
    #  text_node :delivery_status, 'DeliveryStatus', :optional => true
    #  datetime_node :refund_granted_time, 'RefundGrantedTime', :optional => true
    #  datetime_node :refund_requested_time, 'RefundRequestedTime', :optional => true
    #  text_node :status, 'Status', :optional => true
    #  datetime_node :shipped_time, 'ShippedTime', :optional => true
    #  text_node :notes, 'Notes', :optional => true
    #  array_node :shipment_tracking_details, 'ShipmentTrackingDetails', :class => ShipmentTrackingDetails, :default_value => []
    #  array_node :shipment_line_items, 'ShipmentLineItem', 'LineItem', :class => LineItem, :default_value => []
    class Shipment
      include XML::Mapping
      include Initializer
      root_element_name 'Shipment'
      datetime_node :estimated_delivery_date, 'EstimatedDeliveryDate', :optional => true
      money_node :insured_value, 'InsuredValue', :optional => true
      object_node :package_depth, 'PackageDepth', :class => Measure, :optional => true
      object_node :package_length, 'PackageLength', :class => Measure, :optional => true
      object_node :package_width, 'PackageWidth', :class => Measure, :optional => true
      text_node :paypal_shipment_id, 'PayPalShipmentID', :optional => true
      numeric_node :shipment_id, 'ShipmentID', :optional => true
      money_node :postage_total, 'PostageTotal', :optional => true
      datetime_node :printed_time, 'PrintedTime', :optional => true
      object_node :ship_from_address, 'ShipFromAddress', :class => Address, :optional => true
      object_node :shipping_address, 'ShippingAddress', :class => Address, :optional => true
      text_node :shipping_carrier_used, 'ShippingCarrierUsed', :optional => true
      value_array_node :shipping_features, 'ShippingFeature', :default_value => []
      text_node :shipping_package, 'ShippingPackage', :optional => true
      text_node :shipping_service_used, 'ShippingServiceUsed', :optional => true
      text_node :shipment_tracking_number, 'ShipmentTrackingNumber', :optional => true
      object_node :weight_major, 'WeightMajor', :class => Measure, :optional => true
      object_node :weight_minor, 'WeightMinor', :class => Measure, :optional => true
      array_node :item_transaction_ids, 'ItemTransactionID', :class => ItemTransactionID, :default_value => []
      datetime_node :delivery_date, 'DeliveryDate', :optional => true
      text_node :delivery_status, 'DeliveryStatus', :optional => true
      datetime_node :refund_granted_time, 'RefundGrantedTime', :optional => true
      datetime_node :refund_requested_time, 'RefundRequestedTime', :optional => true
      text_node :status, 'Status', :optional => true
      datetime_node :shipped_time, 'ShippedTime', :optional => true
      text_node :notes, 'Notes', :optional => true
      array_node :shipment_tracking_details, 'ShipmentTrackingDetails', :class => ShipmentTrackingDetails, :default_value => []
      array_node :shipment_line_items, 'ShipmentLineItem', 'LineItem', :class => LineItem, :default_value => []
    end
  end
end


