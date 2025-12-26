# TelegramBotApi [![Build Status](https://travis-ci.org/brafales/telegram_bot_api.svg?branch=master)](http://travis-ci.org/brafales/telegram_bot_api)

Telegram Bot Api written in Ruby. Still in early stages, supports for now only a couple of methods.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'telegram_bot_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install telegram_bot_api

## Usage

Configure the gem using this snippet:

```ruby
TelegramBotApi.configure do |config|
  config.auth_token = YOUR_BOT_AUTH_TOKEN
end
```

Once the auth token has been setup, you can create request objects,
configure them to your liking and execute them using the `Client` class.

Here's how to create a `SendMessage` request:

```ruby
request = TelegramBotApi::Requests::SendMessage.new(
  {
    chat_id: 1234,
    text: "This is a test message"
  }
)

TelegramBotApi::Client.execute(request)
```

The gem also provides some simple validation of requests, so you can make sure all the mandatory parameters have been sent:

```ruby
request = TelegramBotApi::Requests::SendMessage.new(
  {
    text: "This is a test message"
  }
)

request.valid? #false
request.errors #[:chat_id]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/brafales/telegram_bot_api.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

