module Android
  class Publisher
    class Apks
      ENDPOINT = 'apks'

      def initialize(connection)
        @client = connection.add_endpoint(ENDPOINT)
      end

      def upload(path_to_apk)
        Response.parse(@client.upload(File.new(path_to_apk)))
      end

      def list
        Response.parse(@client.get)
      end

    end
  end
end
