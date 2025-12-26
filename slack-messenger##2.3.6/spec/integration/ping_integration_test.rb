# frozen_string_literal: true
# encoding: utf-8

require_relative "../../lib/slack-messenger"

ruby = if defined?(JRUBY_VERSION)
  "jruby #{JRUBY_VERSION}"
else
  "ruby #{RUBY_VERSION}"
end
puts "testing with #{ruby}"

messenger = Slack::Messenger.new ENV["SLACK_WEBHOOK_URL"], username: "messenger"
messenger.ping "hello", channel: ["#general", "#random"]
messenger.ping "hello/こんにちは from messenger test script on #{ruby}\225"
messenger.ping attachments: [{ color: "#1BF5AF", fallback: "fallback", text: "attachment" }]
