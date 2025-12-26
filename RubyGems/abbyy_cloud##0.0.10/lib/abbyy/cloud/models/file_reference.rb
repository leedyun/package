class ABBYY::Cloud
  module Models
    class FileReference < Model
      attribute :id,    type: Types::Strict::String
      attribute :token, type: Types::Strict::String
    end

    # Registers type Types::FileReference
    Types.register_type FileReference
  end
end
