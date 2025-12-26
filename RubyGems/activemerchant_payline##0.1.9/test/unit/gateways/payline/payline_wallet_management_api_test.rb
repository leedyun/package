require './test/test_helper'
require "./lib/active_merchant/billing/gateways/payline.rb"

include ActiveMerchant::Billing

class PaylineWalletManagementApi < Test::Unit::TestCase
  def setup
    @gateway = PaylineGateway.new(fixtures(:payline))

    valid_year = Date.today.year + 1 .year
    @random_order_ref = SecureRandom.hex
    @valid_card   = { number: 4970100000325734, brand: "visa", month: 12, year: valid_year, verification_value: 123}
    @invalid_card = { number: "not_a_valid_number", brand: "visa", month: 12, year: valid_year, verification_value: 123}
  end

  ##########################################
  # Tests for create_wallet request
  ##########################################
  def test_successful_create_wallet
    VCR.use_cassette("test_successful_create_wallet") do
      response = @gateway.create_wallet({wallet_id: "JaneDoe_Wallet", card: @valid_card})

      assert_success response
      assert_equal "Operation Successfull", response.params['result']['long_message']
      assert_equal "02500", response.params['result']['code']

      assert_equal "497010XXXXXX5734", response.params['card']['number']
    end
  end

  def test_failed_create_wallet
    VCR.use_cassette("test_failed_create_wallet") do
      # No wallet info
      response = @gateway.create_wallet({})

      assert_failure response
      assert_equal "Invalid value for ", response.params['result']['long_message']
      assert_equal "02308", response.params['result']['code']
    end
  end

  ##########################################
  # Tests for disable_wallet request
  ##########################################
  def test_successful_disable_wallet
    VCR.use_cassette("test_successful_disable_wallet") do
      response = @gateway.disable_wallet("1234567", "JaneDoe_Wallet")

      assert_success response
      assert_equal "Operation Successfull", response.params['result']['long_message']
      assert_equal "02500", response.params['result']['code']

      @gateway.enable_wallet("1234567", "JohnDoe_Wallet")
    end
  end

  def test_failed_disable_wallet
    VCR.use_cassette("test_failed_disable_wallet") do
      # No wallet info
      response = @gateway.disable_wallet("1234567", "Inexisting_wallet")

      assert_success response
      assert_equal "Can not disable some wallet(s) [Inexisting_wallet do not exist]", response.params['result']['long_message']
      assert_equal "02517", response.params['result']['code']
    end
  end

  ##########################################
  # Tests for do_immediate_wallet_payment request
  ##########################################
  def test_successful_do_immediate_wallet_payment
    VCR.use_cassette("test_successful_do_immediate_wallet_payment") do
      @gateway.enable_wallet("1234567", "JaneDoe_Wallet")
      response = @gateway.do_immediate_wallet_payment(1000, "JaneDoe_Wallet",
        {
          order_ref: @random_order_ref,
          currency: "EUR",
          authentication_3D_secure: {}
        }
      )

      assert_success response
      assert_equal "Transaction approved", response.params['result']['long_message']
      assert_equal "00000", response.params['result']['code']
    end
  end

  def test_failed_immediate_wallet_payment
    VCR.use_cassette("test_failed_immediate_wallet_payment") do
      # Fake wallet
      response = @gateway.do_immediate_wallet_payment(1000, "Fakewallet",
        {
          order_ref: @random_order_ref,
          authentication_3D_secure: {}
        }
      )

      assert_failure response
      assert_equal "Wallet does not exist", response.params['result']['long_message']
      assert_equal "02503", response.params['result']['code']

      # No order ref
      response = @gateway.do_immediate_wallet_payment(1000, "JaneDoe_Wallet",
        {
          authentication_3D_secure: {}
        }
      )

      assert_failure response
      assert_equal "Invalid field format : Order Reference : Max length 50 characters", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']

      # Invalid amount
      response = @gateway.do_immediate_wallet_payment("not_a_number", "JaneDoe_Wallet",
        {
          order_ref: @random_order_ref,
          currency: "EUR",
          authentication_3D_secure: {}
        }
      )

      assert_failure response
      assert_equal "Invalid field format : Payment Amount : Must be numeric(12), ex : 15078", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']
    end
  end

  ##########################################
  # Tests for do_recurrent_wallet_payment request
  ##########################################
  def test_successful_do_recurrent_wallet_payment
    VCR.use_cassette("test_successful_do_recurrent_wallet_payment") do
      response = @gateway.do_recurrent_wallet_payment(1000, "JaneDoe_WebWallet", {recurring: {amount: 1000, billing_cycle: :yearly}, order_ref:  @random_order_ref })

      assert_success response
      assert_equal "Operation Successfull", response.params['result']['long_message']
      assert_equal "02500", response.params['result']['code']
      assert_equal "1000", response.params['billing_record_list']['billing_record']['amount']
    end
  end

  def test_failed_do_recurrent_wallet_payment
    VCR.use_cassette("test_failed_do_recurrent_wallet_payment") do
      # Fake wallet
      response = @gateway.do_recurrent_wallet_payment(1000, "FAKEWALLET", {recurring: {amount: 1000, billing_cycle: :yearly}, order_ref:  @random_order_ref })

      assert_failure response
      assert_equal "Contract not associated with card", response.params['result']['long_message']
      assert_equal "02842", response.params['result']['code']

      # Wrong Amount
      response = @gateway.do_recurrent_wallet_payment("not_a_correct_amount", "JaneDoe_WebWallet", {recurring: {amount: 1000, billing_cycle: :yearly}, order_ref:  @random_order_ref })

      assert_failure response
      assert_equal "Internal Error", response.params['result']['long_message']
      assert_equal "02101", response.params['result']['code']

      # Missing Recurring Amount
      response = @gateway.do_recurrent_wallet_payment(1000, "JaneDoe_WebWallet", {recurring: { billing_cycle: :yearly }, order_ref: "test" })

      assert_failure response
      assert_equal "Invalid field format : Recurring amount : Must be numeric(12), ex : 15078", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']

      # Missing Frequency
      response = @gateway.do_recurrent_wallet_payment(1000, "JaneDoe_WebWallet", { recurring: {amount: 1000}, order_ref:  @random_order_ref })

      assert_failure response
      assert_equal "Invalid field format : Recurring billingCycle : Must be numeric(2), ex : 10, 20...", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']

      # Missing Order ID
      response = @gateway.do_recurrent_wallet_payment(1000, "JaneDoe_WebWallet",  recurring: {amount: 1000, billing_cycle: :yearly })

      assert_failure response
      assert_equal "Internal Error", response.params['result']['long_message']
      assert_equal "02101", response.params['result']['code']
    end
  end

  ##########################################
  # Test for do_scheduled_wallet_payment request
  ##########################################
  def test_successful_do_scheduled_wallet_payment
    VCR.use_cassette("test_successful_do_scheduled_wallet_payment") do
      response = @gateway.do_scheduled_wallet_payment(1000, 'JaneDoe_WebWallet', order_ref: @random_order_ref, scheduled_data: Time.now + 1.day)

      assert_success response
      assert_equal "Operation Successfull", response.params['result']['long_message']
      assert_equal "02500", response.params['result']['code']
    end
  end

  def test_failed_do_scheduled_wallet_payment
    VCR.use_cassette("test_failed_do_scheduled_wallet_payment") do
      # Invalid amount
      response = @gateway.do_scheduled_wallet_payment('invalid_amount', 'JaneDoe_WebWallet', order_ref: @random_order_ref, scheduled_data: Time.now + 1.day)

      assert_failure response
      assert_equal "Invalid field format : Payment Amount : Must be numeric(12), ex : 15078", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']

      # Fake wallet
      response = @gateway.do_scheduled_wallet_payment(1000, 'FakeWallet', order_ref: @random_order_ref, scheduled_data: Time.now + 1.day)

      assert_failure response
      assert_equal "Contract not associated with card", response.params['result']['long_message']
      assert_equal "02842", response.params['result']['code']

      # No order ref
      response = @gateway.do_scheduled_wallet_payment(1000, 'JaneDoe_WebWallet', scheduled_data: Time.now + 1.day)

      assert_failure response
      assert_equal "Invalid field format : Order Reference : Max length 50 characters", response.params['result']['long_message']
      assert_equal "02305", response.params['result']['code']
    end
  end

  ##########################################
  # Tests for enable_wallet request
  ##########################################
  def test_successful_enable_wallet
    VCR.use_cassette("test_successful_enable_wallet") do
      @gateway.create_wallet({wallet_id: "JaneAndJohnWallet", card: @valid_card})
      @gateway.disable_wallet("1234567", "JaneAndJohnWallet")
      response = @gateway.enable_wallet("1234567", "JaneAndJohnWallet")

      assert_success response
      assert_equal "Operation Successfull", response.params['result']['long_message']
      assert_equal "02500", response.params['result']['code']
    end
  end

  def test_failed_enable_wallet
    VCR.use_cassette("test_failed_enable_wallet") do
      # No wallet info
      response = @gateway.enable_wallet("1234567", "Inexisting_wallet")

      assert_failure response
      assert_equal "Wallet does not exist", response.params['result']['long_message']
      assert_equal "02503", response.params['result']['code']
    end
  end

  ##########################################
  # Tests for get_wallet request
  ##########################################
  def test_successful_get_wallet
    VCR.use_cassette("test_successful_get_wallet") do
      @gateway.create_wallet({wallet_id: "JaneDoe_Wallet", card: @valid_card})
      response = @gateway.get_wallet("1234567", "JaneDoe_Wallet")

      assert_success response
      assert_equal "Operation Successfull", response.params['result']['long_message']
      assert_equal "02500", response.params['result']['code']
    end
  end

  def test_failed_get_wallet
    VCR.use_cassette("test_failed_get_wallet") do
      # No wallet info
      response = @gateway.get_wallet("1234567", "Inexisting_wallet")

      assert_failure response
      assert_equal "Wallet does not exist", response.params['result']['long_message']
      assert_equal "02503", response.params['result']['code']
    end
  end

  ##########################################
  # Tests for update_wallet request
  ##########################################
  def test_successful_update_wallet
    VCR.use_cassette("test_successful_update_wallet") do
      @valid_card.merge!({ number: 370000000000002, brand: "amex"})
      response = @gateway.update_wallet({wallet_id: "JaneDoe_Wallet", card: @valid_card})

      assert_success response
      assert_equal "Operation Successfull", response.params['result']['long_message']
      assert_equal "02500", response.params['result']['code']

      assert_equal "37000XXXXXX0002", response.params['card']['number']
    end
  end

  def test_failed_update_wallet
    VCR.use_cassette("test_failed_update_wallet") do
      # No wallet info
      response = @gateway.update_wallet({})

      assert_failure response
      assert_equal "Wallet does not exist", response.params['result']['long_message']
      assert_equal "02503", response.params['result']['code']
    end
  end

end
