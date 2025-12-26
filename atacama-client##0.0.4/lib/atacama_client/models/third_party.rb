require "atacama_client/models/base"

module AtacamaClient
  class ThirdParty < AtacamaClient::Base
    get :all, "/third_parties"
    get :find, "/third_parties/:id"

    validates :name, presence: true
    validates :document, presence: true
  end
end