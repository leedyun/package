require './test/test_helper'
require "./lib/active_merchant/billing/gateways/payline.rb"
require 'securerandom'

include ActiveMerchant::Billing
include PaylineWalletManagementAPI

class PaylineDirectApi < Test::Unit::TestCase
  def setup
    @gateway = PaylineGateway.new(fixtures(:payline))

    valid_year = Date.today.year + 1 .year

    @random_order_ref = SecureRandom.hex

    @valid_card   = { number: 4970100000325734, brand: "visa", month: 12, year: valid_year, verification_value: 123}
    @invalid_card = { number: "not_a_valid_number", brand: "visa", month: 12, year: valid_year, verification_value: 123}
  end

  ##########################################
  # Tests for do_authorization request
  ##########################################
  def test_successful_do_authorization
    VCR.use_cassette("test_successful_do_authorization") do
      response = @gateway.do_authorization(1000, @valid_card, order_ref: @random_order_ref,
        bank_account_data: {countryCode: 'FR'}
      )

      assert_success response
      assert_equal "Transaction approved", response.params['result']['long_message']
      assert_equal "00000", response.params['result']['code']
    end
  end

  def test_failed_do_authorization
    VCR.use_cassette("test_failed_do_authorization") do
      # Invalid card number
      response = @gateway.do_authorization(1000, @invalid_card, {order_ref: @random_order_ref})

      assert_failure response
      assert_equal "Invalid field format : Card Number : Bad format, please refer to the user guide", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']

      # Invalid amount
      response = @gateway.do_authorization("this_is_not_a_number", @valid_card, {order_ref: @random_order_ref})

      assert_failure response
      assert_equal "Invalid field format : Payment Amount : Must be numeric(12), ex : 15078", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']

      # No order ID
      response = @gateway.do_authorization(1000, @valid_card)

      assert_failure response
      assert_equal "Invalid field format : Order Reference : Max length 50 characters", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']
    end
  end

  ##########################################
  # Tests for get_payment_record request
  ##########################################
  def test_successful_get_payment_record
    VCR.use_cassette("test_successful_get_payment_record") do
      payment_response = @gateway.do_recurrent_wallet_payment(1000, "JaneDoe_WebWallet", {recurring: {amount: 1000, billing_cycle: :yearly}, order_ref:  @random_order_ref })
      payment_record_id = payment_response.params['payment_record_id']

      response = @gateway.get_payment_record(payment_record_id)

      assert_success response
      assert_equal "Operation Successfull", response.params['result']['long_message']
      assert_equal "02500", response.params['result']['code']
    end
  end

  def test_failed_get_payment_record
    VCR.use_cassette("test_failed_get_payment_record") do
      response = @gateway.get_payment_record("fake_payment_record_id")

      assert_failure response
      assert_equal "Invalid field format : PaymentRecordId : Only numeric", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']
    end
  end

  ##########################################
  # Tests for disable_payment_record request
  ##########################################
  def test_successful_disable_payment_record
    VCR.use_cassette("test_successful_disable_payment_record") do
      payment_response = @gateway.do_recurrent_wallet_payment(1000, "JaneDoe_WebWallet", {recurring: {amount: 1000, billing_cycle: :yearly}, order_ref:  @random_order_ref })
      payment_record_id = payment_response.params['payment_record_id']

      response = @gateway.disable_payment_record(payment_record_id)

      assert_success response
      assert_equal "Operation Successfull", response.params['result']['long_message']
      assert_equal "02500", response.params['result']['code']
    end
  end

  def test_failed_disable_payment_record
    VCR.use_cassette("test_failed_disable_payment_record") do
      response = @gateway.get_payment_record("fake_payment_record_id")

      assert_failure response
      assert_equal "Invalid field format : PaymentRecordId : Only numeric", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']
    end
  end

  private
    def show_response(response)
      puts "----------------"
      puts response.params
    end

    def get_payment_record_id
      resp = @gateway.do_recurrent_wallet_payment(1000, "JaneDoe_WebWallet", {recurring_amount: 1000, frequency: :yearly, order_ref: "test" })
      payment_record_id = resp.params["payment_record_id"]
    end
end
