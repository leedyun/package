module Cnvrg
  class API_V2 < API
    ENDPOINT_VERSION = 'v2'

    class CnvrgAPIError < StandardError; end

    def self.endpoint_uri
      api = get_api()
      return "#{api}/#{Cnvrg::API_V2::ENDPOINT_VERSION}"
    end

    def self.request(resource, method = 'GET', data = {}, parse_request = true)
      resource = URI::encode resource
      n = Netrc.read
      if n['cnvrg.io'].nil?
        puts 'You\'re not logged in'
        puts 'Please log in via `cnvrg login`'
        return
      end

      _, pass = n[Cnvrg::Helpers.netrc_domain]

      conn = Faraday.new endpoint_uri, :ssl => {:verify => !!Helpers.is_verify_ssl}
      conn.headers['Auth-Token'] = pass
      conn.headers['Authorization'] = "CAPI #{pass}"
      conn.headers['User-Agent'] = Cnvrg::API::USER_AGENT
      conn.headers['Content-Type'] = "application/json"
      conn.options.timeout = 420
      conn.options.open_timeout = 180

      20.times do
        begin
          response = send_request conn, resource, method, data
          Cnvrg::API.parse_version response
          is_response_success response
          if parse_request
            return JSON.parse(response.body)
          else
            return response.body
          end
        rescue CnvrgAPIError => e
          raise e
        rescue => e
          Cnvrg::Logger.log_error e
          sleep 0.5
          retry
        end
      end
    rescue CnvrgAPIError => e
      Cnvrg::Logger.log_error e
      raise e
    rescue SignalException
      return false
    rescue => e
      Cnvrg::Logger.log_error e
      return nil
    end

    private

    def self.send_request(conn, resource, method, data)
      case method
      when 'GET'
        conn.get resource, data
      when 'POST'
        conn.post resource, data.to_json
      when 'PUT'
        conn.put resource, data.to_json
      when 'DELETE'
        conn.delete resource, data
      end
    end

    def self.is_response_success(response)
      raise CnvrgAPIError.new(JSON(response.body)['errors']) if response.status != 200
    end
  end
end