require './test/test_helper'
require "./lib/active_merchant/billing/gateways/payline.rb"
require 'securerandom'

include ActiveMerchant::Billing

class PaylineManagementPaymentApi < Test::Unit::TestCase
  def setup
    @gateway = PaylineGateway.new(fixtures(:payline))

    valid_year = Date.today.year + 1 .year
    @random_order_ref = SecureRandom.hex
    @valid_card   = { number: 4970100000325734, brand: "visa", month: 12, year: valid_year, verification_value: 123}
    @invalid_card = { number: "not_a_valid_number", brand: "visa", month: 12, year: valid_year, verification_value: 123}
  end

  ##########################################
  # Tests for do_bank_transfer request
  # Works only between those two banks: "crédit mutuel Arkéa" and "société générale"
  # TODO
  ##########################################
  def test_successful_do_bank_transfer
    VCR.use_cassette("test_successful_do_bank_transfer") do
      response = @gateway.do_bank_transfer(1000, creditor: {bic: "CMTEST", iban: 'FR1420041010050500013M02606', name: "Jane Doe account"})
    end
  end

  ##########################################
  # Tests for do_credit request
  ##########################################
  def test_successful_do_credit
    VCR.use_cassette("test_successful_do_credit") do
      response = @gateway.do_credit(1000, @valid_card, @random_order_ref)

      assert_success response
      assert_equal "Transaction approved", response.params['result']['long_message']
      assert_equal "00000", response.params['result']['code']
    end
  end

  def test_failed_do_credit
    VCR.use_cassette("test_failed_do_credit") do
      # Incorrect amount
      response = @gateway.do_credit("invalid_amount", @valid_card, @random_order_ref)

      assert_failure response
      assert_equal "Invalid field format : Payment Amount : Must be numeric(12), ex : 15078", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']

      # Invalid card
      response = @gateway.do_credit(1000, @invalid_card, @random_order_ref)

      assert_failure response
      assert_equal "Invalid field format : Card Number : Bad format, please refer to the user guide", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']
    end
  end

  ##########################################
  # Tests for do_debit request
  ##########################################
  def test_successful_do_debit
    VCR.use_cassette("test_successful_do_debit") do
      response = @gateway.do_debit(1000, @valid_card, @random_order_ref, authorization: { number: 12345, date: I18n.l(Time.now, format: "%d/%m/%Y %H:%M") })

      assert_success response
      assert_equal "Transaction approved", response.params['result']['long_message']
      assert_equal "00000", response.params['result']['code']
    end
  end

  def test_failed_do_debit
    VCR.use_cassette("test_failed_do_debit") do
      # Invalid amount
      response = @gateway.do_debit("invalid_amount", @valid_card, @random_order_ref, authorization: { number: 12345, date: I18n.l(Time.now, format: "%d/%m/%Y %H:%M") })

      assert_failure response
      assert_equal "Invalid field format : Payment Amount : Must be numeric(12), ex : 15078", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']

      # Invalid card
      response = @gateway.do_debit(1000, @invalid_card, @random_order_ref, authorization: { number: 12345, date: I18n.l(Time.now, format: "%d/%m/%Y %H:%M") })

      assert_failure response
      assert_equal "Invalid field format : Card Number : Bad format, please refer to the user guide", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']

      # No order ref
      response = @gateway.do_debit(1000, @valid_card, "", authorization: { number: 12345, date: I18n.l(Time.now, format: "%d/%m/%Y %H:%M") })

      assert_failure response
      assert_equal "Invalid field format : Order Reference : Max length 50 characters", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']

      # No authorization
      response = @gateway.do_debit("invalid_amount", @valid_card, @random_order_ref)

      assert_failure response
      assert_equal "Invalid field format : authorizationNumber is missing or empty : null", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']
    end
  end

  ##########################################
  # Tests for do_capture request
  ##########################################
  def test_successful_do_capture
    VCR.use_cassette("test_successful_do_capture") do
      transaction = @gateway.do_authorization(1000, @valid_card, {order_ref:  @random_order_ref, action: :authorization })
      transaction_id = transaction.params["transaction"]['id']

      response = @gateway.do_capture(1000, transaction_id, mode: "CPT")

      assert_success response
      assert_equal "Transaction approved", response.params['result']['long_message']
      assert_equal "00000", response.params['result']['code']
    end
  end

  def test_failed_do_capture
    VCR.use_cassette("test_failed_do_capture") do
      # Already a validated transaction
      transaction = @gateway.do_authorization(1000, @valid_card, {order_ref: @random_order_ref, action: :purchase})
      transaction_id = transaction.params["transaction"]['id']

      response = @gateway.do_capture(1000, transaction_id, {currency: "EUR", mode: "CPT"})

      assert_failure response
      assert_equal "The amount is invalid", response.params['result']['long_message']
      assert_equal "02110", response.params['result']['code']
    end
  end

  ##########################################
  # Tests for do_refund request
  ##########################################
  def test_successful_do_refund
    VCR.use_cassette("test_successful_do_refund") do
      transaction = @gateway.do_authorization(1000, @valid_card, {order_ref: @random_order_ref, action: :purchase})
      transaction_id = transaction.params["transaction"]['id']

      response = @gateway.do_refund(1000, transaction_id, { currency: "EUR", mode: "CPT"})

      assert_success response
      assert_equal "Transaction approved", response.params['result']['long_message']
      assert_equal "00000", response.params['result']['code']
    end
  end

  def test_failed_do_refund
    VCR.use_cassette("test_failed_do_refund") do
      transaction = @gateway.do_authorization(1000, @valid_card, {order_ref: @random_order_ref, action: :purchase})

      transaction_id = transaction.params["transaction"]['id']

      # Not a valid amount
      response = @gateway.do_refund('NOT A VALID AMOUNT', transaction_id, { currency: "EUR", mode: "CPT"})

      assert_failure response
      assert_equal "Invalid field format : Payment Amount : Must be numeric(12), ex : 15078", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']

      # fake transaction ID
      response = @gateway.do_refund(1000, 'fake_transaction_id', { currency: "EUR", mode: "CPT"})

      assert_failure response
      assert_equal "Transaction ID  is invalid.", response.params['result']['long_message']
      assert_equal "02301", response.params['result']['code']
    end
  end

  ##########################################
  # Tests for do_reset request
  ##########################################
  def test_successful_do_reset
    VCR.use_cassette("test_successful_do_reset") do
      transaction = @gateway.do_authorization(1000, @valid_card, {order_ref: @random_order_ref, action: :purchase})
      transaction_id = transaction.params["transaction"]['id']

      response = @gateway.do_reset(transaction_id)

      assert_success response
    end
  end

  def test_failed_do_reset
    VCR.use_cassette("test_failed_do_reset") do
      # Fake transaction ID
      response = @gateway.do_reset('fake_transaction_id')

      assert_failure response
      assert_equal "Transaction ID  is invalid.", response.params['result']['long_message']
      assert_equal "02301", response.params['result']['code']
    end
  end

end
