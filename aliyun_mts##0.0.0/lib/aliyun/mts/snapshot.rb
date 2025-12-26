module Aliyun
  module MTS
    module Snapshot
      def self.submit(input = {}, config = {}, pipeline_id = "", user_data = "")
        params = { Action: "SubmitSnapshotJob" }
        params[:Input]          = input.to_json
        params[:SnapshotConfig] = config.to_json
        params[:pipeline_id]    = pipeline_id
        params[:user_data]      = user_data

        uri = URI(BASE_URL)
        uri.query = URI.encode_www_form( Util.signature_params(params))
        res = Net::HTTP.get_response(uri)
        JSON.parse res.body
      end
    end
  end
end