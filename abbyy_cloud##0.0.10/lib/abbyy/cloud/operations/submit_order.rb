require_relative "base"

class ABBYY::Cloud
  module Operations
    class SubmitOrder < Base
      # rubocop: disable Metrics/LineLength
      link "https://api.abbyy.cloud/swagger/ui/index#!/Order/Order_SubmitOrder_0"
      # rubocop: enable Metrics/LineLength
      path { "v0/order" }
      http_method "post"

      request_body do
        attribute :type, type: Types::TranslationType
        attribute :email, type: Types::Strict::String, optional: true
        attribute :contact_culture, type: Types::Strict::String, optional: true
        attribute :contact_utc_offset, type: Types::Coercible::String,
                                       optional: true
        attribute :mt_engine, type: Types::Strict::String,
                              default: proc { false }
        attribute :approval_required, type: Types::Form::Bool,
                                      default: proc { false }
        attribute :is_manual_estimation, type: Types::Form::Bool,
                                         optional: proc { false }
        attribute :unit_type, type: Types::UnitType
        attribute :currency, type: Types::Currency
        attribute :from, type: Types::Locale
        attribute :label, type: Types::Label, optional: true
        attribute :to, type: Types::FilledArray.member(Types::Locale)
        attribute :files, type: Types::FilledArray.member(Types::FileReference)
        attribute :category, type: Types::Strict::String, optional: true
        attribute :cost_type, type:    Types::CostType,
                              default: proc { Models::CostType.new("Default") }
      end

      response_body Models::FullOrder
    end
  end
end
