# TelegramNotifications

TelegramNotifications enables your Rails app to send notifications/messages to your users via Telegram's Bot API


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'telegram_notifications'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install telegram_notifications

## Usage

TelegramNotifications uses a telegram_users table to store all users. To
generate and run the migration just use.

    rails generate telegram_notifications:migration

This will also generate a config file in ```config/initializers/telegram_notifications.rb```,model "telegram_user.rb" and "" . 



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hbasheer/telegram_notifications. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

