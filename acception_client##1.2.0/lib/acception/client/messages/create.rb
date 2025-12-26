module Acception
  module Client
    module Messages
      class Create < Acception::Client::Endpoint

        def initialize( message, attributes={} )
          @message    = message
          @attributes = attributes
        end

      protected

        attr_reader :message

        def message_type
          Acception::MessageType.new( attributes[:message_type] || Acception::MessageType::INFO ).key
        end

        def occurred_at
          occurred_at = attributes[:occurred_at]
          return Time.now.utc.iso8601 unless occurred_at

          occurred_at.is_a?( String ) ?
            occurred_at :
            occurred_at.iso8601
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
