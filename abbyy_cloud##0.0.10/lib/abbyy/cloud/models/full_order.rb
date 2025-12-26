require_relative "currency"
require_relative "order_statistics"
require_relative "label"
require_relative "locale"
require_relative "payment_type"
require_relative "status"
require_relative "translation_link"
require_relative "translation_type"
require_relative "unit_type"

class ABBYY::Cloud
  module Models
    class FullOrder < Model
      attribute :amount, type: Types::Coercible::Float, optional: true
      attribute :approval_required, type: Types::Form::Bool,
                                    default: proc { false }
      attribute :created, type: Types::Form::Time.constrained(type: Time)
      attribute :currency, type: Types::Currency
      attribute :deadline, type: Types::Form::Time, optional: true
      attribute :deleted, type: Types::Form::Time, optional: true
      attribute :delivered, type: Types::Form::Time, optional: true
      attribute :email, type: Types::Strict::String
      attribute :from, type: Types::Locale
      attribute :id, type: Types::Strict::String
      attribute :is_deleted, type: Types::Form::Bool
      attribute :is_layout_required, type: Types::Form::Bool
      attribute :is_manual_estimation, type: Types::Form::Bool,
                                       default: proc { false }
      attribute :label, type: Types::Label, optional: true
      attribute :number, type: Types::Coercible::Int
      attribute :payment_provider, type: Types::Strict::String, optional: true
      attribute :payment_type, type: Types::PaymentType
      attribute :progress, type: Types::Coercible::Int
      attribute :started, type: Types::Form::Time, optional: true
      attribute :statistics, type: Types::OrderStatistics, optional: true
      attribute :status, type: Types::Status
      attribute :to, type: Types::FilledArray.member(Types::Locale)
      attribute :translations, type: Types::Array.member(Types::TranslationLink)
      attribute :type, type: Types::TranslationType
      attribute :unit_count, type: Types::Coercible::Int, optional: true
      attribute :unit_type, type: Types::UnitType, optional: true
      attribute :units_count, type: Types::Hash, optional: true
    end

    # Registers type Types::FullOrder
    Types.register_type FullOrder
  end
end
