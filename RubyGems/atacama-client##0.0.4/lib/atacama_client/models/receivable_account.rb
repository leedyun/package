require "atacama_client/models/base"

module AtacamaClient
  class ReceivableAccount < AtacamaClient::Base
    get :all, "/receivable_accounts"

    validates :name, presence: true
    validates :reason, presence: true
  end
end