module AppfiguresClient
  module Endpoints
    class Endpoint
      def initialize(api, routes)
        @api = api
        @request = api.request
        @routes = routes
      end
    end
  end
end
