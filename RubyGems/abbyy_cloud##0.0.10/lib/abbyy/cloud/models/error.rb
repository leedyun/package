class ABBYY::Cloud
  # Collection of models returned in requests
  module Models
    class Error < Model
      attribute :request_id,        type: Types::Strict::String, optional: true
      attribute :error,             type: Types::Strict::String, optional: true
      attribute :error_description, type: Types::Strict::String, optional: true
      attribute :model_state,       type: Types::Hash.constrained(type: Hash),
                                    optional: true
    end
  end
end
