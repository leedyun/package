require_relative 'payline_common'
include ActiveMerchant::Billing::PaylineCommon

module ActiveMerchant
  module Billing
    module PaylineWebAPI
      # Deprecated method: use manage_web_wallet
      # :buyer [Hash] Buyer data, it must contain :wallet_id, :last_name, :first_name
      # :update_personal_details [Boolean] 0 = Updates forbidden (default) ; 1 = Updates allowed
      # Optional parameters: language_code, custom_payment_page_code, security_mode, notification_url, custom_payment_templace_url
      # Optional objects: contract_number,owner, private_data
      def create_web_wallet(buyer_data, options = {})
        optional_parameters = [
          'languageCode',
          'customPaymentPageCode',
          'securityMode',
          'notificationURL',
          'customPaymentTemplateURL'
        ]

        data = merged_data([
          # Required parameters
          add_buyer(buyer_data),
          add_update_personal_details(options[:update_personal_details]),
          # Optionals parameters
          add_selected_contract_list(options[:contract_number], options[:all_contract_numbers]),
          add_owner(options[:owner]),
          add_private_data(options[:private_data]),
          add_optional_parameters(options, optional_parameters)
        ])

        web_wallet_request :create, data
      end

      # :order_ref [String] Order reference (required)- Must contains 1 to 50 chars (required)
      # :currency [String] Default currency code is default_currency
      # :action [String] Default is :purchase (101 (Authorization + Validation))
      # :mode [String] Default is :direct ("CPT")
      # Optional parameters: notification_url, language_code, custom_payment_page_code, security_mode, recurring, custom_payment_template_url
      # Optional objects: private_data, buyer, owner
      def do_web_payment(amount, options = {})
        optional_parameters = [
          'notificationURL',
          'languageCode',
          'customPaymentPageCode',
          'securityMode', # Required
          'recurring',
          'customPaymentTemplateURL'
        ]

        currency = currency_code(options[:currency])

        data = merged_data([
          # Required parameters
          add_payment(amount, currency, options[:action], options[:mode], options[:payment]),
          add_order(amount, currency, options[:order_ref], options[:order]),
          # Optionals parameters
          add_private_data(options[:private_data]),
          add_buyer(options[:buyer]),
          add_owner(options[:owner]),
          add_selected_contract_list(options[:contract_number], options[:all_contract_numbers]),
          add_optional_parameters(options, optional_parameters)
        ])

        puts data

        web_api_request :do_web_payment, data
      end
      alias_method :setup_purchase, :do_web_payment

      # :token [String] Token
      # TODO: Fix
      def get_web_payment_details(token)
        data = {
          token: token
        }

        web_api_request :get_web_payment_details, data
      end

      # :token [String] token
      # TODO: Fix
      def get_web_wallet(token)
        data = { token: token }

        web_wallet_request :get, data
      end

      # Allows user to manage its registered cards through a web page
      # It returns an url where user must be redirected to handle its cards
      # The URL must be "cleaned" (remove weird characters like amp;)
      # Required parameters
      # :buyer [buyer Object] Buyer data must contain :wallet_id, :first_name, :last_name
      # :update_personal_details [Boolean] Default is 0 (false)
      # Optional parameters: language_code, custom_payment_page_code, security_mode, custom_payment_template_url
      # Optional objects: owner, selected_contract_list, private_data, buyer, contract_number_wallet
      def manage_web_wallet(buyer_data, options = {})
        optional_parameters = [
          'languageCode',
          'customPaymentPageCode',
          'securityMode',
          'notificationURL',
          'customPaymentTemplateURL'
        ]

        data = merged_data([
          # Required parameters
          add_buyer(buyer_data),
          add_update_personal_details(options[:update_personal_details]),
          # Optional parameters
          add_owner(options[:owner]),
          add_private_data(options[:private_data]),
          add_selected_contract_list(options[:contract_number], options[:all_contract_numbers]),
          add_optional_parameters(options, optional_parameters),
          add_contract_number_wallet_list(options[:contract_number_wallet])
        ])

        web_wallet_request :manage, data
      end

      # Deprecated method: use manage_web_wallet
      # :wallet_id [String] Alpha-numeric 50 chars max (required)
      # :update_payment_details [String] 0 = Updates forbidden ; 1 = Updates allowed
      # :update_personal_details [String] 0 = Updates forbidden ; 1 = Updates allowed
      # :update_owner_details [String] 0 = Updates forbidden ; 1 = Updates allowed
      # Optional parameters: card_ind, languate_code, custom_payment_page_code, security_mode, notification_url, custom_payment_template_url
      # Optional objects: buyer, private_data, contract_number_wallet
      def update_web_wallet(wallet_id, options = {})
        optional_parameters = [
          'cardInd',
          'languageCode', 'customPaymentPageCode', 'securityMode', 'notificationURL',
          'customPaymentTemplateURL'
        ]

        required_parameters = {
          wallet_id: wallet_id,
          updatePaymentDetails: format_boolean(options[:update_payment_details], true),
          updateOwnerDetails: format_boolean(options[:updateOwnerDetails], true)
        }

        data = merged_data([
          required_parameters,
          add_update_personal_details(options[:update_personal_details]),
          # Optional parameters
          add_buyer(options[:buyer]),
          add_private_data(options[:private_data]),
          add_contract_number_wallet_list(options[:contract_number_wallet]),
          add_optional_parameters(options, optional_parameters)
        ])

        web_wallet_request :update, data
      end

      protected
        def web_api_request(method_name, data)
          savon_request(web_api_savon_client, method_name, data)
        end

        def web_api_savon_client
          url = test? ? self.web_test_url : self.web_live_url

          @web_api_savon_client ||= create_savon_client(url)
        end

        def web_wallet_request(method_name, data)
          web_api_request :"#{method_name}_web_wallet", data
        end

        def add_web_params(options)
          {
            languageCode: language_code(options[:locale]),
            securityMode: SSL,
            returnURL: options[:return_url],
            cancelURL: options[:cancel_return_url],
            notificationURL: options[:notify_url],
            customPaymentPageCode: options[:custom_payment_page_code],
          }.merge!( add_selected_contract_list(options[:contract_number], options[:all_contract_numbers]) )
        end

        def add_update_personal_details(update_personal_details)
          { updatePersonalDetails: format_boolean(update_personal_details) }
        end

    end
  end
end
