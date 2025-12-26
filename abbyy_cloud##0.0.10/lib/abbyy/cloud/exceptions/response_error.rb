# The exception to be risen when ABBYY Cloud API responded with error status.
# It takes a raw Net::HTTPResponse and extracts all the data returned by API.
class ABBYY::Cloud
  class ResponseError < StandardError
    attr_reader :status, :data

    def initialize(response)
      @status = response.code.to_i
      @data   = Models::Error[parse_response(response)] unless @status == 500
      super
    end

    private

    def message
      <<-MESSAGE.gsub(/ +\|/, "")
        |ABBYY Cloud API responded to the request #{data&.request_id} with a status #{status}
        |  error:       #{data&.error}
        |  description: #{data&.error_description}
        |  model_state: #{data&.model_state}
      MESSAGE
    end

    def parse_response(response)
      JSON.parse(response.body)
    rescue
      { error: "Server error", error_description: response.body }
    end
  end
end
