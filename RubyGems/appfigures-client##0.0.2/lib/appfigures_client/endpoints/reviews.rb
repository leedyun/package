module AppfiguresClient
  module Endpoints
    class Reviews < Endpoint


      def search(options={})
        path = @routes[:default]
        @request.make path, options
      end

      def counts(options={})
        path = @routes[:count]
        @request.make path, options
      end

    end

  end
end
