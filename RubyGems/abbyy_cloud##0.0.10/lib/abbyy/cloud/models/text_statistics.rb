require_relative "source_tag"

class ABBYY::Cloud
  module Models
    class TextStatistics < Model
      attribute :language,    type: Types::Locale
      attribute :pages_count, type: Types::Coercible::Int
      attribute :words_count, type: Types::Coercible::Int
      attribute :chars_count, type: Types::Coercible::Int
    end

    # Registers type Types::TextStatistics
    Types.register_type TextStatistics
  end
end
