module AppfiguresClient
  module Net
    class Request

      def initialize(options)
        @username = options[:username]
        @password = options[:password]
        @client_key = options[:client_key]
      end

      def make(path = '', params = {})
        uri = ::URI.parse(Api::URL + path)
        http = ::Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        request_params = params ? '?' + parameterize(params) : ''

        req = ::Net::HTTP::Get.new(uri.path + request_params)
        req.basic_auth @username, @password
        req['X-CLIENT-KEY'] = @client_key

        response = http.request req
        parsed = JSON.parse(response.body)
        parsed.kind_of?(Array) ? parsed.collect {|hash| hash.with_indifferent_access } : parsed.with_indifferent_access
      end

      private

      def parameterize(params)
        URI.escape(params.collect { |k, v| "#{k}=#{v}" }.join('&'))
      end

    end
  end
end
