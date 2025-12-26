# frozen_string_literal: tru

require 'ruboty/adapters/base'
require 'telegram/bot'

module Ruboty
  module Adapters # :nodoc:
    class Telegram < Base # :nodoc:
      env :TELEGRAM_TOKEN, 'Account\'s token'

      def run
        init
        listen
      end

      def say(message)
        chat_id = message[:to]
        body    = message[:body]
        text    = message[:code] ? "```\n#{body}\n```" : body

        api.send_message(chat_id: chat_id, text: text, parse_mode: 'Markdown')
      end

      private

      def client
        @client ||= ::Telegram::Bot::Client.new(ENV['TELEGRAM_TOKEN'])
      end

      def api
        client.api
      end

      def init
        response = api.get_me
        ENV['RUBOTY_NAME'] = response['result']['username']
      end

      def listen
        client.listen do |message|
          on_message(message)
        end
      end

      def on_message(message)
        from_name = [message.from.first_name, message.from.last_name].join(' ')

        robot.receive(
          body: message.text,
          from: message.chat.id,
          from_name: from_name,
          to: message.chat.id
        )
      end
    end
  end
end
