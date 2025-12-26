require 'uri'
require 'json'

module Android
  class Publisher
    class Connection
      API_URL     = URI.parse('https://www.googleapis.com/androidpublisher/v2/applications/')

      UPLOAD_URL  = URI.parse('https://www.googleapis.com/upload/androidpublisher/v2/applications/')

      def initialize(authorized_connection, package_name, endpoints = [])
        @authorized_connection  = authorized_connection
        @package_name           = package_name
        @endpoints              = endpoints
      end

      def add_endpoint(endpoint)
        Connection.new(authorized_connection,package_name, [*@endpoints, endpoint])
      end

      def remove_endpoint
        Connection.new(authorized_connection,package_name, @endpoints[0..-2])
      end

      def put(params = {})
        authorized_connection.put(append(""), params)
      end

      def get(path = "")
        authorized_connection.get(append(path))
      end

      def just_post(path = "", params = {})
        authorized_connection.post(URI.join(API_URL, "#{package_name}/", path), params)
      end

      def post(path = "", params = {})
        authorized_connection.post(append(path), params)
      end



      def delete(path = "")
        authorized_connection.delete(append(path))
      end

      def patch(path = "", params = {})
        authorized_connection.patch(append(path), params)
      end

      def upload(file)
        params = {
          :headers => { 'Content-Type' => 'application/octet-stream', 'Content-Length'=> file.size.to_s },
          :body    => Faraday::UploadIO.new(file.path, 'application/octet-stream')
        }

        authorized_connection.post(upload_uri, params)
      end

      private
      attr_reader :authorized_connection, :package_name, :endpoints

      def upload_uri
        URI.join(UPLOAD_URL, "#{package_name}/", get_endpoints, "?uploadType=media").to_s
      end

      def response(response_body)
        JSON.parse response_body
      end

      def append(path)
        path.gsub!(/^\//, "")
        URI.join(API_URL, "#{package_name}/", get_endpoints, path).to_s
      end

      def get_endpoints
        endpoints.empty? ? "" : "#{endpoints.join("/")}/"
      end
    end
  end
end
