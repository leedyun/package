module Acception
  module Client
    module Data
      class Create < Acception::Client::Endpoint

        def initialize( data, attributes={} )
          @data       = data
          @attributes = attributes
        end

      protected

        attr_reader :data

        def message_type
          Acception::MessageType::DATA.key
        end

        def occurred_at
          occurred_at = attributes[:occurred_at]
          return Time.now.utc.iso8601 unless occurred_at

          occurred_at.is_a?( String ) ?
            occurred_at :
            occurred_at.iso8601
        end

        def variables
          [
            {
              name: attributes[:name],
              content: data,
              content_type: attributes[:content_type]
            }.reject { |k,v| v.blank? }
          ]
        end

        def endpoint
          '/messages'
        end

        def http_verb
          :post
        end

        def success_error_codes
          [201]
        end

      end
    end
  end
end
