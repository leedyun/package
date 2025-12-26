require "flexirest"
require "atacama_client/version"
require "atacama_client/models/configuration"
require "atacama_client/models/third_party"
require "atacama_client/models/base"
require "atacama_client/models/receivable"
require "atacama_client/models/company"
require "atacama_client/models/receivable_account"
require "atacama_client/models/installment"

module AtacamaClient
  def self.configuration
    Configuration.instance
  end

  def self.configure(&block)
    block.call configuration
  end

  Flexirest::Base.base_url = "http://atacama.coyo.com.br/api"
end
