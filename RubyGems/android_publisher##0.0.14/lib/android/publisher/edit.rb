module Android
  class Publisher
    class Edit
      ENDPOINT = "edits"

      def initialize(connection, version_code)
        @client       = connection.add_endpoint(ENDPOINT)
        @version_code = version_code
      end

      def insert
        response  = Response.parse(@client.post)
        @id       = response['id']
        @client   = @client.add_endpoint(id)
        response
      end

      def get
        Response.parse(@client.get)
      end

      def commit
        response = connection.commit
        reset_status
        response
      end

      def delete
        if (id)
          response = Response.parse(@client.delete)
          reset_status
          response
        else
          raise "Edit is not created, please insert one"
        end
      end

      def track_has_deployed_apks?(track)
        Track.new(@client, track).has_deployed_apks?
      end

      def rollout_fraction
        Track.new(@client, :rollout).rollout_fraction
      end

      def upload_apk(path_to_apk)
        apks.upload(path_to_apk)
      end

      def assign_to_alpha_track
        Track.new(@client, :alpha).update(version_code)
      end

      def assign_to_beta_track
        Track.new(@client, :beta).update(version_code)
      end

      def assign_to_production_track
        Track.new(@client, :production).update(version_code)
      end

      def assign_to_staged_rollout_track(user_fraction)
        Track.new(@client, :rollout).update(version_code, user_fraction)
      end

      def update_rollout(user_fraction)
        Track.new(@client, :rollout).patch(version_code, user_fraction)
      end

      def clear_rollout
        Track.new(@client, :rollout).update(nil)
      end

      def clear_beta
        Track.new(@client, :beta).update(nil)
      end

      private
      attr_reader :client, :id

      def reset_status
        @client = @client.remove_endpoint
        @id     = nil
      end

      def apks
        Apks.new(@client)
      end

      def apk_latest_version_code
        apks.list['apks'].last['versionCode']
      end

      def version_code
        @version_code || apk_latest_version_code
      end

      def connection
        @connection ||= Android::Publisher::EditConnection.new(@client, @id)
      end
    end
  end
end
