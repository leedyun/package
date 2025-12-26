class ABBYY::Cloud
  module Models
    class TransferData < Model
      attribute :position, type: Types::Strict::Int
      attribute :order,    type: Types::Strict::Int
    end

    # Registers type Types::TransferData
    Types.register_type TransferData
  end
end
