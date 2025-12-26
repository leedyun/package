require_relative 'payline_common'
include ActiveMerchant::Billing::PaylineCommon

module ActiveMerchant
  module Billing
    module PaylineWalletManagementAPI

      # Optional parameters: media
      # Required objects: Wallet
      # Optional objects: buyer, owner,  private_data, authentication_3D_secure, contract_number_wallet
      def create_wallet(wallet, options = {})
        optional_parameters = ['media']
        data = merged_data([
          # Required parameters
          add_wallet(wallet),
          # Option parameters,
          add_buyer(options[:buyer]),
          add_owner(options[:owner]),
          add_private_data(options[:private_data]),
          add_authentication_3D_secure(options[:authentication_3D_secure]),
          add_optional_parameters(options, optional_parameters),
          add_contract_number_wallet_list(options[:contract_number_wallet])
        ])

        direct_api_request :create_wallet, data
      end

      def disable_wallet(contract_number, wallet_id, options={})
        optional_parameters = ['cardInd']
        required_parameters = { contractNumber: contract_number}

        data = merged_data([
          required_parameters,
          add_optional_parameters(options, optional_parameters),
          add_wallet_id_list(wallet_id)
        ])

        direct_api_request :disable_wallet, data
      end

      # :wallet_id [String] Wallet ID
      # :order_ref [String] Order ID (required)
      # Required parameters: order_ref, wallet_id, buyer
      # Optional parameters: card_ind, media, wallet_cvx
      # Required objects: order, payment, authentication_3D_secure
      # Optional parameters: private_data
      def do_immediate_wallet_payment(amount, wallet_id, options = {})
        currency = currency_code(options[:currency])

        optional_parameters = ['cardInd', 'media', 'walletCvx']
        required_parameters = {
          walletId:  wallet_id
        }

        buyer_options = options[:buyer].blank? ? { wallet_id: wallet_id} : options[:buyer]

        data = merged_data([
          # Required parameters
          required_parameters,
          add_payment( amount, currency, options[:action], :direct, options[:payment]),
          add_order( amount, currency, options[:order_ref], options[:order]),
          add_buyer(buyer_options),
          # Optional parameters
          add_private_data(options[:private_data]),
          add_authentication_3D_secure(options[:authentication_3D_secure]),
          add_optional_parameters(options, optional_parameters)
        ])

        direct_api_request :do_immediate_wallet_payment, data
      end

      # :wallet_id [String] Wallet ID
      # :order_ref [String] Order ID (required)
      # Required parameters: order_ref, order_data, schedule_date, wallet_id
      # Optional parameters: card_ind, media
      # Required objects: payment, recurring
      # Optional parameters: order, private_data
      def do_recurrent_wallet_payment(amount, wallet_id, options = {})
        currency = currency_code(options[:currency])

        optional_parameters = ['cardInd', 'media']
        required_parameters = {
          orderRef:  options[:order_ref],
          orderDate: options[:order_date], # Doesnt seem required
          scheduledDate: options[:scheduled_date], # Doesnt seem required
          walletId:  wallet_id,
        }

        data = merged_data([
          # Required parameters
          required_parameters,
          add_payment( amount, currency, options[:action], :recurrent, options[:payment]),
          add_recurring( options[:recurring]),
          # Optional parameters
          add_order( amount, currency, options[:order_ref], options[:order]),
          add_private_data(options[:private_data]),
          add_optional_parameters(options, optional_parameters)
        ])

        direct_api_request :do_recurrent_wallet_payment, data
      end

      # :wallet_id [String] Wallet ID
      # :order_ref [String] Order ID (required)
      # Required parameters: order_ref, wallet_id, scheduled_date (doesn't seem that required)
      # Optional parameters: card_ind, media, wallet_cvx
      # Required objects: order, payment, authentication_3D_secure
      # Optional parameters: private_data
      def do_scheduled_wallet_payment(amount, wallet_id, options = {})
        currency = currency_code(options[:currency])

        optional_parameters = ['cardInd', 'media', 'orderDate']
        required_parameters = {
          walletId:  wallet_id,
          scheduledDate: options[:scheduled_data],
          orderRef: options[:order_ref]
        }

        buyer_options = options[:buyer].blank? ? { wallet_id: wallet_id} : options[:buyer]

        data = merged_data([
          # Required parameters
          required_parameters,
          add_payment( amount, currency, options[:action], :direct, options[:payment]),
          add_order( amount, currency, options[:order_ref], options[:order]),
          # Optional parameters
          add_private_data(options[:private_data]),
          add_optional_parameters(options, optional_parameters)
        ])

        direct_api_request :do_scheduled_wallet_payment, data
      end


      # :wallet_id [String] Wallet ID
      # Required parameters: contract_number, wallet_id
      # Optional parameters: card_ind
      def enable_wallet(contract_number, wallet_id, options={})
        optional_parameters = ['cardInd']
        required_parameters = {
          contractNumber: contract_number,
          walletId: wallet_id
        }

        data = merged_data([
          required_parameters,
          add_optional_parameters(options, optional_parameters)
        ])

        direct_api_request :enable_wallet, data
      end

      # :wallet_id [String] Wallet ID
      # Required parameters: contract_number, wallet_id
      # Optional parameters: card_ind
      def get_wallet(contract_number, wallet_id, options={})
        optional_parameters = ['cardInd', 'media']
        required_parameters = {
          contractNumber: contract_number,
          walletId: wallet_id
        }

        data = merged_data([
          required_parameters,
          add_optional_parameters(options, optional_parameters)
        ])

        direct_api_request :get_wallet, data
      end

      # Optional parameters: card_ind, media
      # Required objects: Wallet
      # Optional objects: buyer, owner,  private_data, authentication_3D_secure, contract_number_wallet
      def update_wallet(wallet, options = {})
        optional_parameters = ['cardInd', 'media']
        data = merged_data([
          # Required parameters
          add_wallet(wallet),
          # Option parameters
          add_buyer(options[:buyer]),
          add_owner(options[:owner]),
          add_private_data(options[:private_data]),
          add_authentication_3D_secure(options[:authentication_3D_secure]),
          add_optional_parameters(options, optional_parameters),
          add_contract_number_wallet_list(options[:contract_number_wallet])
        ])

        direct_api_request :update_wallet, data
      end

      private
        # Optional parameters: first_amount, billing_left, start_date, end_date, new_amount, amount_modification_date
        # Required parameters: amount, billing_cycle
        def add_recurring(recurring_data)
          optional_parameters = ['firstAmount', 'billingLeft', 'startDate', 'endDate', 'newAmount', 'amountModificationDate']
          if recurring_data
            required_parameters = {
              amount:       recurring_data[:amount],
              billingCycle: PaylineCommon::RECURRING_FREQUENCIES[recurring_data[:billing_cycle]]
            }
            objects = [
              required_parameters,
              add_optional_parameters(options, optional_parameters)
            ]

            data = { recurring: merged_data(objects)}
          end
          data ||= { recurring: {} }
        end

        # Optional parameters: last_name, first_name, email, comment, default, card_status, card_brand
        # Required parameters: wallet_id
        # Required objects: card
        # Optional objects: shipping_address
        def add_wallet(wallet_data)
          if wallet_data
            optional_parameters = ['lastName', 'firstName', 'email', 'comment', 'default', 'cardStatus', 'cardBrand']
            required_parameters = {
              walletId: wallet_data[:wallet_id]
            }

            objects = [
              # Required parameters
              required_parameters,
              add_credit_card(wallet_data[:card]),
              # Optional parameters
              add_address(wallet_data[:shipping_address], :shipping_address),
              add_optional_parameters(wallet_data, optional_parameters)
            ]

            data = { wallet: merged_data(objects) }
          end

          data ||= {}
        end

        def add_wallet_id_list(wallet_id)
          if wallet_id
            data = { walletIdList:
              {
                walletId: wallet_id
              }
            }
          end
          data ||= {}
        end
    end
  end
end
