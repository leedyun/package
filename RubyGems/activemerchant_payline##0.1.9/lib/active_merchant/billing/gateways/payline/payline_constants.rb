require_relative '../../iso_4217_currency_codes'

module PaylineConstants

  WDSL_URL = 'https://services.payline.com/V4/services/WebPaymentAPI?wsdl'.freeze
  WDSL_TEST_URL = 'https://homologation.payline.com/V4/services/WebPaymentAPI?wsdl'.freeze

  WEB_API_VERSION = '16'.freeze

  IMPL_NAMESPACE = 'http://impl.ws.payline.experian.com'.freeze
  OBJ_NAMESPACE = 'http://obj.ws.payline.experian.com'.freeze

  LOG_FILTERED_TAGS = %w( number cvx ).freeze

  DATE_FORMAT = "%d/%m/%Y".freeze
  DATETIME_FORMAT = "#{DATE_FORMAT} %H:%M".freeze

  ACTION_CODES = {
    :authorization => 100, # Authorization
    :purchase      => 101, # Authorization + Validation
    :capture       => 201  # Validation
  }.freeze

  CARD_BRAND_CODES = Hash.new('CB').update(
    'visa'             => 'VISA',
    'master'           => 'MASTERCARD',
    'american_express' => 'AMEX',
    'diners_club'      => 'DINERS',
    'jcb'              => 'JCB',
    'switch'           => 'SWITCH',
    'maestro'          => 'MAESTRO'
  ).freeze

  EXPIRATION_DATE_FORMAT = "%.2d%.2d".freeze

  PAYMENT_MODES = {
    :direct       => 'CPT',
    :deffered     => 'DIF',
    :installments => 'NX',
    :recurrent    => 'REC'
  }.freeze

  # locale => ISO 639-2 code
  LANGUAGE_CODES = {
    'fr' => 'fre',
    'en' => 'eng',
    'es' => 'spa',
    'it' => 'ita',
    'pt' => 'por',
    'de' => 'ger',
    'nl' => 'dut',
    'fi' => 'fin'
  }.freeze

  RECURRING_FREQUENCIES = {
    :daily       => 10,
    :weekly      => 20,
    :fortnightly => 30,
    :monthly     => 40,
    :bimonthly   => 50,
    :quarterly   => 60,
    :semiannual  => 70,
    :yearly      => 80,
    :biannual    => 90
  }.freeze

  SSL = 'SSL'.freeze

  SUCCESS_MESSAGES = {
    # Card & Check
    "00000" => "Transaction approved",
    "01001" => "Transaction approved but required a verification by merchant",
    # Wallet
    "02500" => "Operation successful",
    "02501" => "Operation successful but wallet will expire",
    "02517" => "Cannot disable some wallet(s)",
    "02520" => "Cannot enable some wallet(s)",
    # Cancelling & Reauthorizing
    "02616" => "Error while creating the wallet"
  }.freeze

  SUCCESS_CODES = SUCCESS_MESSAGES.keys.freeze
end
