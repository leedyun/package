require_relative 'payline_common'
include ActiveMerchant::Billing::PaylineCommon

module ActiveMerchant
  module Billing
    module PaylineManagementPaymentAPI

      # Optional parameters: comment, transaction_id, order_id
      # Required objects: payment, creditor
      def do_bank_transfer(amount, options = {})
        optional_parameters = ['comment', 'transactionID', 'orderID']

        data = merged_data([
          # Required parameters
          add_payment(amount, currency_code(options[:currency]), options[:action], options[:mode], options[:payment]),
          add_creditor(options[:creditor]),
          # Optional parameters
          add_optional_parameters(options, optional_parameters)
        ])

        direct_api_request :do_bank_transfer, data
      end

      # :amount [Number] Amount of transaction (required)
      # :transaction_id [String] Transaction id (required)
      # :currency [String] Default currency code is default_currency
      # :mode [String] CPT for Full (default) / DIF for Deferred/ NX for N instalments / REC for Recurring
      # Optional parameters: sequence_number, media
      # Optional objects: payment
      def do_capture(amount, transaction_id, options = {})
        optional_parameters = ['sequenceNumber', 'media']
        required_parameters = { transactionID: transaction_id }

        data = merged_data([
          # Required parameters
          required_parameters,
          add_payment(amount, currency_code(options[:currency]), 201, options[:mode], options[:payment]),
          # Optional parameters
          add_private_data(options[:private_data]),
          add_optional_parameters(options, optional_parameters)
        ])

        direct_api_request :do_capture, data
      end
      alias_method :capture, :do_capture

      # Optional parameters: comment, media
      # Required objects: payment, card, order
      # Optional objects: buyer, owner, private_data, optional_parameters
      def do_credit(amount, credit_card, order_ref, options = {})
        optional_parameters = ['comment', 'media']

        data = merged_data([
          # Required parameters
          add_payment(amount, currency_code(options[:currency]), 422, options[:mode], options[:payment]),
          add_credit_card(credit_card),
          add_order(amount, currency_code(options[:currency]), order_ref, options[:order]),
          # Optional parameters
          add_buyer(options[:buyer]),
          add_owner(options[:owner]),
          add_private_data(options[:private_data]),
          add_optional_parameters(options, optional_parameters)
        ])

        direct_api_request :do_credit, data
      end

      # Optional parameters: media
      # Required objects: payment, card, order, authorization
      # Optional parameters: buyer, owner, private_data
      def do_debit(amount, credit_card, order_ref, options = {})
        optional_parameters = ['media']

        data = merged_data([
          # Required parameters
          add_payment(amount, currency_code(options[:currency]), 204, options[:mode], options[:payment]),
          add_credit_card(credit_card),
          add_order(amount, currency_code(options[:currency]), order_ref, options[:order]),
          add_authorization(options[:authorization]), # Seems to be required
          # Optional parameters
          add_buyer(options[:buyer]),
          add_owner(options[:owner]),
          add_private_data(options[:private_data]),
          add_optional_parameters(options, optional_parameters)
        ])

        direct_api_request :do_debit, data
      end

      # :amount [Number] Amount of transaction
      # :transaction_id [String] Transaction id
      # :currency [String] Default currency code is default_currency
      # :mode [String] CPT for Full (default) / DIF for Deferred/ NX for N instalments / REC for Recurring
      # Optional parameters: comment, sequence_number, media
      # Optional objects: payment
      def do_refund(amount, transaction_id, options = {})
        optional_parameters = ['comment', 'sequenceNumber', 'media']
        required_parameters = { transactionID: transaction_id }

        data = merged_data([
          # Required parameters
          required_parameters,
          add_payment(amount, currency_code(options[:currency]), 421, options[:mode], options[:payment]),
          # Optional parameters
          add_optional_parameters(options, optional_parameters)
        ])

        direct_api_request :do_refund, data
      end
      alias_method :refund, :do_refund

      # Transaction_id [String] Transaction id (required)
      # Optional parameters: comment, sequence_number, media
      def do_reset(transaction_id, options = {})
        optional_parameters = ['comment', 'sequenceNumber', 'media']
        required_parameters = { transactionID: transaction_id }

        data = merged_data([
          # Required parameters
          required_parameters,
          # Optional parameters
          add_optional_parameters(options, optional_parameters)
        ])

        direct_api_request :do_reset, data
      end
      alias_method :void, :do_reset

      private
        def add_creditor(creditor_data)
          if creditor_data
            required_parameters = {
              bic: creditor_data[:bic],
              iban: creditor_data[:iban],
              name: creditor_data[:name]
            }
          end
          data = { creditor: required_parameters }
        end

        def add_authorization(authorization_data)
          if authorization_data
            required_parameters = {
              number: authorization_data[:number],
              date: authorization_data[:date]
            }
          end
          required_parameters ||= {}

          data = {authorization: required_parameters}
        end
    end
  end
end
