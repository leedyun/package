require './test/test_helper'
require "./lib/active_merchant/billing/gateways/payline.rb"

include ActiveMerchant::Billing

class PaylineStatusApi < Test::Unit::TestCase
  def setup
    @gateway = PaylineGateway.new(fixtures(:payline))

    @random_order_ref = SecureRandom.hex
    @valid_card   = { number: 4970100000325734, brand: "visa", month: 12, year: Date.today.year + 1.year, verification_value: 123}
  end

  ##########################################
  # Tests for get_transaction_details request
  ##########################################
  def test_get_transaction_details
    VCR.use_cassette("test_get_transaction_details") do
      transaction_id = @gateway.do_authorization(1000, @valid_card, order_ref: @random_order_ref,
        bank_account_data: {countryCode: 'FR'}
      ).params['transaction']['id']

      response = @gateway.get_transaction_details(transaction_id)

      assert_success response
      assert_equal "Transaction approved", response.params['result']['long_message']
      assert_equal "00000", response.params['result']['code']
    end
  end
end
