require 'activemerchant'
require_relative 'payline/payline_constants'
require_relative 'payline/payline_common'
require_relative 'payline/payline_direct_api'
require_relative 'payline/payline_management_payment_api'
require_relative 'payline/payline_wallet_management'
require_relative 'payline/payline_web_api'
require_relative 'payline/payline_status_api'

module ActiveMerchant
  module Billing
    class PaylineGateway < Gateway
      include PaylineCommon
      include PaylineDirectAPI
      include PaylineWalletManagementAPI
      include PaylineManagementPaymentAPI
      include PaylineWebAPI
      include PaylineStatusAPI
      include ISO4217CurrencyCodes

      API_VERSION = '4.24'.freeze

      self.display_name = 'Payline'
      self.homepage_url = 'http://www.payline.com/'

      self.default_currency = 'EUR'
      self.money_format = :cents
      self.supported_cardtypes = [:visa, :master, :american_express, :diners_club, :jcb]

      class_attribute :web_live_url, :web_test_url, :instance_writer => false

      class_attribute :extended_payment_url, :extended_test_payment_url, :instance_writer => false

      self.live_url = 'https://services.payline.com/V4/services/DirectPaymentAPI'.freeze
      self.test_url = 'https://homologation.payline.com/V4/services/DirectPaymentAPI'.freeze

      self.web_live_url = 'https://services.payline.com/V4/services/WebPaymentAPI/'.freeze
      self.web_test_url = 'https://homologation.payline.com/V4/services/WebPaymentAPI/'.freeze

      self.extended_payment_url = 'https://services.payline.com/V4/services/ExtendedAPI'.freeze
      self.extended_test_payment_url = 'https://homologation.payline.com/V4/services/ExtendedAPI'.freeze

      # :merchant_id [String]
      # :merchant_secret [String]
      # :contract_number [String] Contract Number
      # :return_url [String] Return url - Must begin with http:// or https://
      # :cancel_return_url [String] Cancel url - Must begin with http:// or https://
      # :test [Boolean] Set it to true if you want to point to homologation services
      def initialize(options = {})
        requires!(options, :merchant_id, :merchant_access_key, :contract_number)
        @options = options
      end
    end

    Payline = ActiveSupport::Deprecation::DeprecatedConstantProxy.new('ActiveMerchant::Billing::Payline', PaylineGateway)
  end
end
