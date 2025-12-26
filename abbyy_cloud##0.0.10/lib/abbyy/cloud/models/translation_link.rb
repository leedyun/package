require_relative "status"
require_relative "file_link"

class ABBYY::Cloud
  module Models
    class TranslationLink < Model
      attribute :delivered,   type: Types::Form::Time, optional: true
      attribute :started,     type: Types::Form::Time, optional: true
      attribute :progress,    type: Types::Hash,       default:  proc { {} }
      attribute :status,      type: Types::Status
      attribute :source_file, type: Types::FileLink
      attribute :target_file, type: Types::FileLink
    end

    # Registers type Types::TranslationLink
    Types.register_type TranslationLink
  end
end
