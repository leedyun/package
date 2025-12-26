module Acception
  module Client
    module Errors
      class Create < Acception::Client::Endpoint

        def initialize( error, attributes={} )
          @error      = error
          @attributes = attributes
        end

      protected

        attr_reader :error

        def message
          error.try :message
        end

        def message_type
          Acception::MessageType.new( attributes[:message_type] || Acception::MessageType::ERROR ).key
        end

        def stack
          stack = error.try( :backtrace )
          return nil unless stack

          clean_text_for_request( stack.join( "\n" ))
        end

        def type
          error.try( :class ).try( :name )
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
