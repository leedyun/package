module AppfiguresClient
    module Endpoints
      class Ads < Endpoint


        def search(options={})
          path = @routes[:default]
          @request.make path
        end

      end
    end
  end
