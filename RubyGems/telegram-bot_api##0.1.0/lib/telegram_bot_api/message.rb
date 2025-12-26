module TelegramBotApi
  class Message

    attr_reader :text, :chat

    def initialize(payload)
      @text = payload["text"]
      @chat = payload["chat"]
    end
  end
end
