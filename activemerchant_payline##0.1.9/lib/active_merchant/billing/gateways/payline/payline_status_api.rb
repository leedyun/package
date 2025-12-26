require_relative 'payline_common'
include ActiveMerchant::Billing::PaylineCommon

module ActiveMerchant
  module Billing
    module PaylineStatusAPI
      # Required parameter: transaction_id
      # Optional parameters: order_ref, start_date, end_date, transaction_history, archive_search
      def get_transaction_details(transaction_id, options={})
        optional_parameters = ['orderRef', 'startDate', 'endDate', 'transactionHistory', 'archiveSearch']
        required_parameters = { transaction_id: transaction_id }

        data = merged_data([
          # Required parameters
          required_parameters,
          # Optional parameters
          add_optional_parameters(options, optional_parameters)
        ])

        extended_api_request :get_transaction_details, data
      end

      protected
        def extended_api_request(method_name, data)
          savon_request(extended_api_savon_client, method_name, data)
        end

        def extended_api_savon_client
          url = test? ? self.extended_test_payment_url : self.extended_payment_url

          @extended_api_savon_client ||= create_savon_client(url)
        end

    end
  end
end
