module TelegramBotApi
  module Requests
    class SendMessage

      def initialize(arguments = {})
        build_arguments(arguments)
      end

      class << self
        def mandatory_arguments
          %i(chat_id text)
        end

        def optional_arguments
          %i(disable_web_page_preview reply_to_message_id reply_markup)
        end

        def endpoint_url
          'sendMessage'
        end

        def verb
          :post
        end
      end

      include Base
    end
  end
end
