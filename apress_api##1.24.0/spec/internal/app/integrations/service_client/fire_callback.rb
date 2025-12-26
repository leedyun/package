module ServiceClient
  class FireCallback < Apress::Api::Callbacks::BaseCallback
    def call
      "Fired"
    end
  end
end
