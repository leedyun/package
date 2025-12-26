# Omniauth DingTalk

This project forked from [https://github.com/jinhucheung/omniauth-dingding](https://github.com/jinhucheung/omniauth-dingding).

To use it, you'll need to sign up for an OAuth2 Application ID and Secret on the [DingTalk Applications Page](https://open-dev.dingtalk.com/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-dingtalk-oauth2'
```

And then execute:

```
$ bundle install
```

## Usage

`OmniAuth::Strategies::Dingtalk` is simply a Rack middleware. Read the OmniAuth docs for detailed instructions: https://github.com/intridea/omniauth.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dingtalk, ENV['DINGTALK_APP_ID'], ENV['DINGTALK_APP_SECRET']
end
```

## Contributing

Bug reports and pull requests are welcome on GitLab at https://gitlab.com/gitlab-jh/jh-team/omniauth-dingtalk.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
