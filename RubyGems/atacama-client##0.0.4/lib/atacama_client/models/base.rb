module AtacamaClient
  class Base < Flexirest::Base
    request_body_type :json
    before_request :add_api_token

    private
      def add_api_token(name, request)
        request.get_params[:api_token] = AtacamaClient.configuration.api_token
      end
  end
end