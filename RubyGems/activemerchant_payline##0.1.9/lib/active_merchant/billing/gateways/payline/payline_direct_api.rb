require_relative 'payline_common'
include ActiveMerchant::Billing::PaylineCommon

module ActiveMerchant
  module Billing
    module PaylineDirectAPI
      # :amount [Number] Amount of transaction (required)
      # :credit_card [Hash] Credit card informations - Must contain number, brand, month, year, verification_value (required)
      # :order_ref [String] Order ref (required)
      # :currency [String] Default currency code is default_currency
      # :action [String] Default is :purchase (101 (Authorization + Validation))
      # :mode [String] Default is :direct ("CPT")
      # Optional parameters: media
      # Optional objects: buyer, private_data, contract_number_wallet
      def do_authorization(amount, credit_card, options = {})
        #requires!(options, :order_id, :credit_card)
        currency = currency_code(options[:currency])
        action = options[:action] || :authorization

        optional_parameters = ['media']

        data = merged_data([
          # Required parameters
          add_payment(amount, currency, action, options[:mode], options[:payment]),
          add_bank_account_data(options[:bank_account_data]), # Doest seem required
          add_credit_card(credit_card),
          add_order(amount, currency, options[:order_ref], options[:order]),
          # Optional parameters
          add_buyer(options[:buyer]),
          add_owner(options[:owner]),
          add_private_data(options[:private_data]),
          add_authentication_3D_secure(options[:authentication_3D_secure]),
          add_optional_parameters(options, optional_parameters)
        ])

        direct_api_request :do_authorization, data
      end
      alias_method :authorize, :do_authorization

      # payment_record_id [String] Payment record ID, can be retrieved after a do_recurrent_wallet_payment request (required)
      def get_payment_record(payment_record_id)
        payment_record_request :get, payment_record_id
      end

      # payment_record_id [String] Payment record ID, can be retrieved after a do_recurrent_wallet_payment request (required)
      def disable_payment_record(payment_record_id)
        payment_record_request :disable, payment_record_id
      end

      protected
        def payment_record_request(method_name, payment_record_id)
          data = { paymentRecordId: payment_record_id }
          direct_api_request :"#{method_name}_payment_record", data
        end

        def add_bank_account_data(bank_account_data)
          if bank_account_data
            optional_parameters = {
              countryCode: bank_account_data[:country_code],
              bankCode: bank_account_data[:bank_code],
              accountNumber: bank_account_data[:account_number],
              key: bank_account_data[:key]
            }

            parameters = [add_optional_parameters(bank_account_data, optional_parameters)]

            data = { bankAccountData: merged_data(parameters) }
          end

          data ||= {}
        end

        def expiration_date(month, year)
          EXPIRATION_DATE_FORMAT % [month, year.to_s[-2..-1]]
        end
    end
  end
end
