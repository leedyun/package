require_relative '../../iso_4217_currency_codes'
require 'savon'

module ActiveMerchant
  module Billing
    module PaylineCommon

      include PaylineConstants

      protected
        # Make a savon request
        def savon_request(client, method_name, data)
          add_shared_data(data)

          response = client.call :"#{method_name}", { message: data }

          if response.success?
            response = response.to_hash[:"#{method_name}_response"]
            build_response(response)
          else
            message = (response.soap_fault? ? response.soap_fault : response.http_error).to_s
            Response.new(false, message, {}, { :test => test? })
          end
        end

        def direct_api_request(method_name, data)
          savon_request(direct_api_savon_client, method_name, data)
        end

        def direct_api_savon_client
          @direct_api_savon_client ||= create_savon_client(test? ? test_url : live_url)
        end

        # Create a savon client
        def create_savon_client(endpoint)
          Savon.client(
            wsdl:         test? ? WDSL_TEST_URL : WDSL_URL,
            endpoint:     endpoint,
            basic_auth:   [options[:merchant_id], options[:merchant_access_key]],
            log: options[:log] ? options[:log] : false
          )
        end

        def build_response(response)
          message = message_from(result = response[:result])
          if transaction = response[:transaction]
            transaction_id = transaction[:id] if String === transaction[:id]
          end
          format_response!(response = response.with_indifferent_access)
          Response.new(success?(result), message, response, {
            :authorization => transaction_id,
            :test => test?
          })
        end

        def message_from(result)
          message = result[:short_message]
          message << ": " << result[:long_message] unless result[:long_message] == message
          message << " (code #{result[:code]})"
          message
        end

        def success?(result)
          SUCCESS_CODES.include?(result[:code])
        end

        def contract_number
          options[:contract_number]
        end

        def language_code(locale)
          LANGUAGE_CODES[locale.to_s.downcase] if locale
        end

        def format_date(time)
          time.strftime(DATETIME_FORMAT)
        end

        def format_boolean(boolean, default = false)
          case boolean.nil? ? default : boolean
            when true, 1
              1
            else
              0
          end
        end

        def format_response!(response)
          unless response.delete("@xmlns") && response.empty?
            response.each do |key, value|
              if Hash === value
                response[key] = format_response!(value)
              elsif Array === value
                value.map! { |el| format_response!(el) }
              end
            end
          end
        end

        # Merge shared data with data
        # Shared data are version, contract_number and others parameters in add_web_params
        def add_shared_data(data)
          hashes_to_merge = [add_version, add_contract_number, add_web_params(options)]
          shared_data = hashes_to_merge.inject(&:merge)

          data.merge!(shared_data)
        end

        # Optional parameters: md, pares, xid, eci, cavv, cavv_algorithm, vads_result, type_securisation, pa_res_status, ve_res_status
        def add_authentication_3D_secure(authentication_3D_secure)
          if authentication_3D_secure
            optional_parameters = ['md',
              'pares',
              'xid',
              'eci',
              'cavv',
              'cavvAlgorithm',
              'vadsResult',
              'typeSecurisation',
              'PaResStatus',
              'VeResStatus'
            ]

            objects = [add_optional_parameters(authentication_3D_secure, optional_parameters)]

            data = {
              authentication3DSecure: merged_data(objects)
            }
          end
          data ||= {}
        end

        def add_contract_number
          { contractNumber: contract_number }
        end

        def add_contract_number_wallet_list(contract_number)
          if contract_number
            data = { contractNumberWalletList:
              {
                contractNumberWallet: contract_number
              }
            }
          end
          data ||= {}
        end

        def add_credit_card(card)
          if card
            parameters = {
              number: card[:number],
              type: CARD_BRAND_CODES[card[:brand]],
              expirationDate: expiration_date(card[:month], card[:year]),
              cvx: card[:verification_value]
            }
            data = { card: parameters }
          end
          data ||= { card: {} }
        end

        def add_version
          {version: WEB_API_VERSION}
        end

        def add_owner(owner_data)
          optional_parameters = ['lastName', 'firstName', 'issueCardDate']

          if owner_data
            objects = [
              add_address(owner_data[:billing_address], :billing_address),
              add_optional_parameters(owner_data, optional_parameters)
            ]
            data = { owner: merged_data(objects) }
          end

          data ||= {}
        end

        def add_payment(amount, currency, action, mode = nil, options = {})
          optional_parameters = ['differedActionDate', 'method', 'softDescriptor', 'cardBrand']
          required_parameters = {
            amount:   amount,
            currency: currency,
            action:   action_code(action),
            mode:     payment_mode(mode),
            contractNumber: contract_number
          }

          parameters = [
            required_parameters,
            add_optional_parameters(options, optional_parameters)
          ]

          data = { payment: merged_data(parameters) }
        end

        def add_order(amount, currency, ref, options)
          optional_parameters = ['origin',
            'country',
            'taxes',
            'details',
            'deliveryMode',
            'deliveryExpectedDate',
            'deliveryExpectedDelay'
          ]

          date = options[:date] if !options.blank?
          date ||= Time.now

          required_parameters = {
            amount: amount,
            currency: currency,
            ref: ref,
            date: format_date(date)
          }

          details = add_details(options[:details]) if options &&  options[:details]

          parameters = [
            required_parameters,
            # Optional parameters
            details,
            add_optional_parameters(options, optional_parameters)
          ]

          data = { order: merged_data(parameters) }
        end

        def add_buyer(buyer_data)
          optional_parameters = [
            'title',
            'lastName',
            'firstName',
            'email',
            'accountCreateDate',
            'accountAverageAmount',
            'accountOrderCount',
            'walletId',
            'walletDisplayed',
            'walletSecured',
            'walletCardInd',
            'ip',
            'mobilePhone',
            'customerId',
            'legalStatus',
            'legalDocument',
            'birthDate',
            'fingerprintID',
            'deviceFingerprint',
            'isBot',
            'isIncognito',
            'isBehindProxy',
            'isFromTor',
            'isEmulator',
            'isRooted',
            'hasTimezoneMismatch'
          ]

          if buyer_data
            # Note: Yes, shipping_adress with only one d because of Payline wrong attribute...
            objects = [
              add_address(buyer_data[:shipping_address], :shipping_adress),
              add_address(buyer_data[:billing_address], :billing_address),
              add_optional_parameters(buyer_data, optional_parameters)
            ]

            data = { buyer: merged_data(objects) }
          end

          data ||= { buyer: {} }
        end

        def add_address(address, address_name = :address)
          optional_parameters = [
            'title',
            'name',
            'firstName',
            'lastName',
            'street1',
            'street2',
            'cityName',
            'zipCode',
            'country', # TODO Values
            'phone',
            'state',
            'county',
            'phoneType' # TODO Values
          ]

          data = { "#{address_name}": add_optional_parameters(address, optional_parameters) } unless address.blank?
          data ||= {}
        end

        def action_code(action)
          action = :purchase if action.blank?
          if ACTION_CODES.key?(action)
            ACTION_CODES[action]
          else
            action
          end
        end

        def payment_mode(mode)
          mode = :direct if mode.blank?
          if PAYMENT_MODES.key?(mode)
            PAYMENT_MODES[mode]
          else
            mode
          end
        end

        def add_details(details_data)
          optional_parameters = [
            'ref', 'price', 'quantity', 'comment', 'category', 'brand', 'subcategory1', 'subcategory2', 'additionalData', 'taxRate'
          ]
          data =  { details: add_optional_parameters(details_data, optional_parameters) }
          data ||= { details: {} }
        end

        def add_private_data(private_data)
          data = {}
          if private_data
            i = 0

            private_data.to_hash.each do |key, value|
              data.merge!({ "privateData_#{i}": { key: key, value: value } })
              i += 1
            end
            data = { privateDataList: data}
          end
          data ||= {}
        end

        def add_selected_contract_list(contract_number, all_contract_numbers = [])
          if !all_contract_numbers.blank?
            data = { selectedContractList: { selectedContract: all_contract_numbers.uniq } }
          elsif contract_number
            data = { selectedContractList: { selectedContract: contract_number } }
          end
          data ||= {}
        end

        def underscore(camel_cased_word)
          camel_cased_word.to_s.gsub(/::/, '/').
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").
            downcase
        end

        def add_optional_parameters(options, optional_parameters=[])
          data = {}
          if options
            optional_parameters.each do |parameter|
              value = options[underscore(parameter).to_sym]

              data.merge!({"#{parameter}".to_sym => value}) unless value.blank?
            end
          end
          data
        end

        def merged_data(data = [])
          data.reject{|x| x.blank?}.inject(&:merge)
        end
    end
  end
end
