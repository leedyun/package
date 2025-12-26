require "atacama_client/models/base"
require "atacama_client/models/installment"

module AtacamaClient
  class Receivable < AtacamaClient::Base
    post :create, "/receivables",     :has_many => {:installments => Installment}
    put  :update, "/receivables/:id", :has_many => {:installments => Installment}
    get  :find,   "/receivables/:id", :has_many => {:installments => Installment}

    validates :company_id, presence: true
    validates :financial_account_id, presence: true
    validates :date, presence: true
    validates :third_party_id, presence: true
    validates :first_due_date, presence: true
    validates :total_value, presence: true, numericality:true
    validates :installments_number, presence: true, numericality:true
    validates :document_type, presence: true
    validates :document_number, presence: true
    validates :installments do |object, name, value|
      if value.nil? || value.empty?
        object._errors[name] << "must be present"
      else
        value.each do |i|
          unless i.valid?
            i.full_error_messages.each {|e| object._errors[name] << e}
          end
        end
      end
    end
  end
end