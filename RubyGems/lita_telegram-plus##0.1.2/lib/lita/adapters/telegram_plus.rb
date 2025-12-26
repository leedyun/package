require 'telegram/bot'

module Lita
  module Adapters
    class TelegramPlus < Adapter
      config :token, type: String, required: true

      def initialize(robot)
        super
        @client = Telegram::Bot::Client.new(config.token, logger: ::Logger.new($stdout))
        robot.trigger(:connected)
      end

      # Connect to Telegram and listen to incoming messages
      def run
        @client.listen do |message|
          user = Lita::User.find_by_id(message.from.id)
          user = Lita::User.create(id: message.from.id, name: message.from.first_name) unless user

          if user.name == user.id
            user = Lita::User.create(id: message.from.id, name: message.from.first_name)
          end

          chat = Lita::Room.new(message.chat.id)
          source = Lita::Source.new(user: user, room: chat)

          message.text ||= ''
          message = Lita::Message.new(robot, message.text, source)

          robot.receive(message)
        end
      end

      # Send messages to the Telegram bot api
      def send_messages(target, messages)
        messages.each do |message|
          @client.api.send_message(chat_id: target.room.to_i, text: message)
        end
      end

      # Disconnect from Telegram
      def shutdown
      end

      Lita.register_adapter(:telegram_plus, self)
    end
  end
end

# user
## id
## first_name
## last_name
## username
