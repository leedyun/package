require_relative "file_reference"
require_relative "locale"

class ABBYY::Cloud
  module Models
    class FileLink < FileReference
      attribute :name,        type: Types::Strict::String
      attribute :language,    type: Types::Locale
      attribute :is_deleted,  type: Types::Form::Bool
      attribute :chars_count, type: Types::Coercible::Int, optional: true
      attribute :words_count, type: Types::Coercible::Int, optional: true
      attribute :pages_count, type: Types::Coercible::Int, optional: true
    end

    # Registers type Types::FileLink
    Types.register_type FileLink
  end
end
