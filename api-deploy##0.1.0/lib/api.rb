module API
  attr_reader :api

  def create_api(config)
    @api = Faraday.new(url: config.url) do |connection|
      connection.ssl[:verify] = false
      connection.adapter :net_http
      if config.api_key
        connection.headers['X-Octopus-ApiKey'] = config.api_key
      else
        connection.basic_auth(config.user, config.pass)
      end
    end
  end

  def request(method, url, query=nil, type="json", parse=true)
    if query
      Log.warn "request url: #{method.upcase} #{api.url_prefix}#{url}"
      Log.info "request body: #{query}"
      response = api.send(method) do |request|
        request.url url
        request.body = query
        request.headers['Content-Type'] = "application/#{type}"
      end
    else
      Log.warn "request url: #{method.upcase} #{api.url_prefix}#{url}"
      response = api.send(method) do |request|
        request.url url
        request.headers['Content-Type'] = "application/#{type}"
      end
    end

    Log.warn "response code: #{response.status}"
    Log.info "response body: #{response.body}"
    parse ? parsed_response(response) : response
  end

  def parsed_response(resp)
    if resp.headers['content-type'] =~ /application\/json/
      JSON.parse(resp.body)
    else
      resp
    end
  end
end
