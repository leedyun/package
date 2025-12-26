module AdvisorsCommandClient
  module Models
    class ContactCollection
      def initialize(args = {})
        @connection = args[:connection]
      end

      def search(query)
        response = @connection.get('search', {search: query, from: 'oro_contact'})
        if response.success?
          return Parallel.map(Array(response.body['data'])) do |obj|
            begin
              next unless obj['record_string']
              self.find(obj['record_id'].to_i)
            rescue Faraday::Error::ParsingError
              puts "Error parsing response for contact ID: #{obj['record_id']}"
              next nil
            end
          end.compact
        else
          raise ::AdvisorsCommandClient::SearchError, "Error connecting to advisors command."
        end
      end

      def find(contact_id)
        resp = @connection.get("contacts/#{contact_id}")
        if resp.success?
          return AdvisorsCommandClient::Models::Contact.load(resp.body, @connection)
        else
          return nil
        end
      end

      def create(params)
        contact = AdvisorsCommandClient::Models::Contact.new(params)
        resp = @connection.post("contacts.json", { contact: contact.as_json })

        if resp.success?
          contact.id = resp.body['id']
          return contact
        else
          return false
        end
      end

      def update(contact_id, params)
        contact = AdvisorsCommandClient::Models::Contact.new(params.merge(id: contact_id))
        resp = @connection.put("contacts/#{contact_id}.json", { contact: contact.as_json })

        if resp.success?
          return contact
        else
          return false
        end
      end
    end
  end
end