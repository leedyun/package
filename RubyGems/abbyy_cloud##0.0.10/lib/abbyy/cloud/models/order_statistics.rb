require_relative "source_tag"

class ABBYY::Cloud
  module Models
    class OrderStatistics < Model
      attribute :documents_count, type: Types::Coercible::Int
      attribute :pages_count,     type: Types::Coercible::Int
      attribute :words_count,     type: Types::Coercible::Int
      attribute :chars_count,     type: Types::Coercible::Int
    end

    # Registers type Types::OrderStatistics
    Types.register_type OrderStatistics
  end
end
