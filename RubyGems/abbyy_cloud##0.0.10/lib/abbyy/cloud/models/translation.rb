class ABBYY::Cloud
  module Models
    class Translation < Model
      attribute :id,          type: Types::Strict::String
      attribute :translation, type: Types::Strict::String
    end
  end
end
