module Aliyun
  module MTS
    module MediaInfo
      def self.submit(input = {}, pipeline_id = "", user_data = "")
        params = { Action: "SubmitMediaInfoJob" }
        params[:Input]       = input.to_json
        params[:pipeline_id] = pipeline_id
        params[:user_data]   = user_data

        uri = URI(BASE_URL)
        uri.query = URI.encode_www_form( Util.signature_params(params))
        res = Net::HTTP.get_response(uri)
        JSON.parse res.body
      end
    end
  end
end