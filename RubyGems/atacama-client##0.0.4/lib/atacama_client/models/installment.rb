require "atacama_client/models/base"

module AtacamaClient
  class Installment < AtacamaClient::Base
    validates :number, presence: true
    validates :value, presence: true
    validates :due_date, presence: true
  end
end