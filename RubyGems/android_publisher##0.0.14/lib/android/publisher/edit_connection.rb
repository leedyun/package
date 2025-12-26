module Android
  class Publisher
    class EditConnection
      ENDPOINT = "edits"
      def initialize(client, edit_id)
        @client  = client
        @edit_id = edit_id
      end

      def commit
        Response.parse(client.just_post("edits/#{edit_id}:commit"))
      end

      private
      attr_reader :client, :edit_id
    end
  end
end
