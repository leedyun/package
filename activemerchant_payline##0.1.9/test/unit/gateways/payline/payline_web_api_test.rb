require './test/test_helper'
require "./lib/active_merchant/billing/gateways/payline.rb"

include ActiveMerchant::Billing

class PaylineWebApi < Test::Unit::TestCase
  def setup
    @gateway = PaylineGateway.new(fixtures(:payline))

    valid_year = Date.today.year + 1 .year
    @random_order_ref = SecureRandom.hex
    @valid_card   = { number: 4970100000325734, brand: "visa", month: 12, year: valid_year, verification_value: 123}
  end

  ##########################################
  # Tests for create_web_wallet request
  ##########################################
  def test_successful_create_web_wallet
    VCR.use_cassette("test_successful_create_web_wallet") do
      response = @gateway.create_web_wallet(
        {
          first_name: "Jane",
          last_name: "Doe",
          wallet_id: "JaneDoe_WebWallet",
          shipping_address: { title: "My House"}
        },
        owner: {first_name: "Jane"},
        notification_url: "test.com",
        contract_number: "1234567",
        private_data: { key1: "value_1", key2: "value_2"})

      assert_success response
      assert_equal "Transaction approved", response.params['result']['long_message']
      assert_not_nil response.params['token']
    end
  end

  def test_missing_parameters_create_web_wallet
    VCR.use_cassette("test_missing_parameters_create_web_wallet") do
      # Try to create wallet withour wallet_id
      response = @gateway.create_web_wallet(
        {
          first_name: "Jane",
          last_name: "Doe"
        })

      assert_failure response
      assert_equal nil, response.params['token']
      assert_equal "Wallet Id required for wallet", response.params['result']['long_message']

      # Try to create wallet withour firstname and lastame
      response = @gateway.create_web_wallet(
        {
          wallet_id: "JaneDoe_WebWallet"
        })
      assert_failure response
      assert_equal nil, response.params['token']
      assert_equal "Lastname and Firstname required for wallet", response.params['result']['long_message']
    end
  end

  ##########################################
  # Tests for do_web_payment request
  ##########################################
  def test_successful_do_web_payment
    VCR.use_cassette("test_successful_do_web_payment") do
      response = @gateway.do_web_payment(100, currency: "EUR",
        order_ref: "1",
        notificationURL: "test.com",
        owner: {first_name: "Jane"},
        buyer: {first_name: "John"}
      )

      assert_success response
      assert_equal "Transaction approved", response.params['result']['long_message']
      assert_equal "00000", response.params['result']['code']
      assert_not_nil response.params['token']
    end
  end

  def test_failed_do_web_payment
    VCR.use_cassette("test_failed_do_web_payment") do
      response = @gateway.do_web_payment("This_is_not_a_correct_amount", currency: "EUR", order_ref: "1")

      assert_failure response
      assert_not_equal "00000", response.params['result']['code']
      assert_equal nil, response.params['token']
    end
  end

  def test_missing_parameters_do_web_payment
    VCR.use_cassette("test_missing_parameters_do_web_payment") do
      # Try to create wallet withour order_ref
      response = @gateway.do_web_payment(100, currency: "EUR")

      failure_assertions_do_web_payment(response)
    end
  end

  ##########################################
  # Tests for get_web_payment_details request
  # TODO: Bug from payline homologation?
  ##########################################
  def test_successful_get_web_payment_details
    VCR.use_cassette("test_successful_get_web_payment_details") do
      resp = @gateway.do_web_payment(100, currency: "EUR", order_ref: "1")
      #resp = @gateway.do_authorization(1000, @valid_card, {order_ref: @random_order_ref})
      token = resp.params["token"]

      response = @gateway.get_web_payment_details(token)
    end
  end

  def test_failed_get_web_payment_details
    VCR.use_cassette("test_failed_get_web_payment_details") do
      token = "fake_token"
      response = @gateway.get_web_payment_details(token)

      assert_failure response
      assert_equal "This token does not exist", response.params['result']['long_message']
      assert_equal nil, response.params['token']
    end
  end

  ##########################################
  # Tests for get_web_wallet request
  # TODO: Bug from payline homologation?
  ##########################################
  def test_get_web_wallet
    VCR.use_cassette("test_get_web_wallet") do
      resp = @gateway.create_web_wallet(
        {
          first_name: "Jane",
          last_name: "Doe",
          wallet_id: "JaneDoe_WebWallet2"
        })
      token = resp.params["token"]

      #puts "TOKEN: #{token}"

      response = @gateway.get_web_wallet(token)

      #show_response(response)

      #assert_success response
    end
  end

  ##########################################
  # Tests for manage_web_wallet request
  ##########################################
  def test_successful_manage_web_wallet
    VCR.use_cassette("test_successful_manage_web_wallet") do
      response = @gateway.manage_web_wallet(
        { wallet_id: "JohnDoe_WebWallet", first_name: "John", last_name: "Doe" },
        { owner: {firstname: "John"} }
      )

      assert_success response
      assert_equal "Transaction approved", response.params['result']['long_message']
      assert_not_nil response.params['token']
    end
  end

  def test_failed_manage_web_wallet
    VCR.use_cassette("test_failed_manage_web_wallet") do
      # Try to manage wallet without wallet_id
      response = @gateway.manage_web_wallet({ first_name: "John", last_name: "Doe" })

      assert_failure response
      assert_equal "Wallet Id required for wallet", response.params['result']['long_message']
      assert_equal nil, response.params['token']

      # Try to manage wallet without firstname and lastname
      response = @gateway.manage_web_wallet({ wallet_id: "JohnDoe_WebWallet" })

      assert_failure response
      assert_equal "Lastname and Firstname required for wallet", response.params['result']['long_message']
      assert_equal nil, response.params['token']
    end
  end

  ##########################################
  # Tests for update_web_wallet request
  # To make it pass, theJaneDoe_WebWallet must exist on account
  ##########################################
  def test_successful_update_web_wallet
    VCR.use_cassette("test_successful_update_web_wallet") do
      response = @gateway.update_web_wallet("JaneDoe_WebWallet",
        contract_number_wallet: "1234567"
      )

      assert_success response
      assert_equal "Transaction approved", response.params['result']['long_message']
      assert_not_nil response.params['token']
    end
  end

  def test_failed_update_web_wallet
    VCR.use_cassette("test_failed_update_web_wallet") do
      response = @gateway.update_web_wallet("Wallet_That_Doesnt_Exist")

      assert_failure response
      assert_equal "Wallet does not exist", response.params['result']['long_message']
      assert_equal nil, response.params['token']
    end
  end

  private
    def show_response(response)
      puts "----------------"
      puts response.params
    end

    def failure_assertions_do_web_payment(response)
      assert_failure response
      assert_not_equal "00000", response.params['result']['code']
      assert_equal nil, response.params['token']
    end

end
