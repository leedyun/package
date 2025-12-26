class Apitool::Client::ApitoolClient

  def initialize(params = {})
    @host       ||= params[:host]
    @port       ||= params[:port]
    @ssl        ||= params[:ssl] || false
    @token      ||= params[:token]
    @version    ||= params[:version] || 'v1'
    @symbolize  ||= params[:symbolize] || true

    default_ssl_verification = (@ssl) ? OpenSSL::SSL::VERIFY_PEER : OpenSSL::SSL::VERIFY_NONE
    @verify_ssl ||= params[:verify_ssl] || default_ssl_verification
  end

  def response
    @response.nil? ? nil : parse(@response)
  end

  def request
    @request.nil? ? nil : @request.args
  end

  def result
    @result.nil? ? nil : @result.code.to_i
  end

  def errors

  end

protected

  def get_connection
    @client ||= RestClient::Resource.new(
      base_uri,
      verify_ssl: @verify_ssl
    )
  end

  def get(path, options = {})
    get_connection[request_uri(path)].get(headers) { |response, request, result, &block|
      _update(response, request, result)
      yield response, request, result if block_given?
    }
  end

  def post(path, parameters)
    get_connection[request_uri(path)].post(parameters.to_json, headers) { |response, request, result, &block|
      _update(response, request, result)
      yield response, request, result if block_given?
    }
  end

  def put(path, parameters)
    get_connection[request_uri(path)].put(parameters.to_json, headers) { |response, request, result, &block|
      _update(response, request, result)
      yield response, request, result if block_given?
    }
  end

  def delete(path)
    get_connection[request_uri(path)].delete(headers) { |response, request, result, &block|
      _update(response, request, result)
      yield response, request, result if block_given?
    }
  end

  def parse(data)
    JSON.parse(data, symbolize_names: @symbolize)
  end

private

  def _update(_response, _request, _result)
    @response = _response
    @request  = _request
    @result   = _result

    log = "#{result} - #{request[:method].upcase} - #{request[:url]} - payload[#{request[:payload] || ''}]"
    if response.present? and (response.kind_of? Array and response[0].has_key?(:message)) || (response.kind_of? Hash and response.has_key?(:errors))
      log = log + " - error['#{response.inspect}']"
    end
    logger.info log
  end

  def base_uri
    if @ssl
      "https://#{@host}:#{@port}"
    else
      "http://#{@host}:#{@port}"
    end
  end

  def request_uri(path)
    "/api/#{@version}#{path}"
  end

  def headers
    {
      content_type:   :json,
      accept:         :json,
      authorization:  "Token token=#{@token}"
    }
  end

  def logger
    Apitool::Client.logger
  end

end
