module Android
  class Publisher
    class Track
      ENDPOINT = 'tracks'
      def initialize(client, track)
        @track  = track.to_s
        @client = client.add_endpoint("#{ENDPOINT}/#{@track}")
      end

      def has_deployed_apks?
        list['versionCodes'].size > 0
      end

      def rollout_fraction
        list['userFraction']
      end

      def update(version_code, user_fraction=nil)
        params = {
          :headers => { "Content-Type" => 'application/json' },
          :body    => { :track => @track, :versionCodes => [version_code], :userFraction=>user_fraction }.to_json
        }

        Response.parse(@client.put(params))
      end

      def patch(version_code, user_fraction)
        params = {
            :headers => { "Content-Type" => 'application/json' },
            :body    => { :track => @track, :versionCodes => [version_code], :userFraction=>user_fraction }.to_json
        }

        Response.parse(@client.patch("", params))
      end

      private
      attr_reader :track

      def list
        begin
          Response.parse(@client.get())
        rescue OAuth2::Error
          {'versionCodes' => [], 'userFraction' => -1}
        end
      end
    end
  end
end
