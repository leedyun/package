module Acception
  module Client
    module OpenMessages
      class Create < Acception::Client::Endpoint

        def initialize( attributes )
          @attributes = attributes
        end

      protected

        def occurred_at
          (attributes[:occurred_at] || Time.now.utc).iso8601
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
