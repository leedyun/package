# Omniauth AliCloud

To use it, you'll need to sign up for an OAuth2 Application ID and Secret on the [Alicloud Oauth Applications Page](https://ram.console.aliyun.com/applications).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-alicloud'
```

And then execute:

```
$ bundle install
```

## Usage

`OmniAuth::Strategies::Alicloud` is simply a Rack middleware. Read the OmniAuth docs for detailed instructions: https://github.com/intridea/omniauth.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :alicloud, ENV['ALICLOUD_APP_SECRET_ID'], ENV['ALICLOUD_APP_SECRET_KEY']
end
```

## Contributing

Bug reports and pull requests are welcome on GitLab at https://gitlab.com/gitlab-jh/jh-team/omniauth-alicloud.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
