module Android
  class Publisher
    class Response
      class << self
        #TODO: create proper object instead of parsing response
        def parse(response)
          if response.status == 204
            { :status => "OK" }
          else
            JSON.parse response.body
          end
        end
      end

      def initialize(body)

      end
    end
  end
end
