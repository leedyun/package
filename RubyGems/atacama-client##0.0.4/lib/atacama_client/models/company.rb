require "atacama_client/models/base"

module AtacamaClient
  class Company < AtacamaClient::Base
    get :all, "/companies"
    get :find, "/companies/:id"

    validates :name, presence: true
    validates :identification, presence: true
  end
end