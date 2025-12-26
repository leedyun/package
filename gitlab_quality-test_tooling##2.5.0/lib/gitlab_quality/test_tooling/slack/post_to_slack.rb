# frozen_string_literal: true

module GitlabQuality
  module TestTooling
    module Slack
      class PostToSlack
        def initialize(slack_webhook_url:, channel:, message:, username:, icon_emoji:)
          @slack_webhook_url = slack_webhook_url
          @channel = channel
          @message = message
          @username = username
          @icon_emoji = icon_emoji
        end

        def invoke!
          params = {}
          params['channel'] = channel
          params['username'] = username
          params['icon_emoji'] = icon_emoji
          params['text'] = message

          Support::HttpRequest.make_http_request(
            method: 'post',
            url: slack_webhook_url,
            params: params,
            show_response: true
          )
        end

        private

        attr_reader :slack_webhook_url, :channel, :message, :username, :icon_emoji
      end
    end
  end
end
