module TelegramBotApi
  module Requests
    class SetWebhook

      def initialize(arguments = {})
        build_arguments(arguments)
      end

      class << self
        def mandatory_arguments
          []
        end

        def optional_arguments
          %i(url)
        end

        def endpoint_url
          'setWebhook'
        end

        def verb
          :get
        end
      end

      include Base
    end
  end
end
