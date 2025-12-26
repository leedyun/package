[![Build Status](https://travis-ci.org/mkcode/education_stats.svg?branch=master)](https://travis-ci.org/mkcode/education_stats)

# EducationStats

This gem serves as an abstract Statd client which forwards Statsd commands to
one or many configured Statsd clients. These clients may include a
HostedGraphite client, which can be built using an API key.

## Usage

Configure the client. The following example sets up two Statsd clients, one on
HostedGraphite, and one manually configured. All that is needed to use a
HostedGraphite client is to set the `hostedgraphite_api_key`. As many clients as
you like may be added through the `add_statsd_client` method. A namespace for
hostedgraphite may also be set using the `hosted_graphite_namespace=` method.

```ruby
  other_client = Statsd.new(ENV['STATSD_HOST'], ENV['STATSD_PORT'], ENV['STATSD_KEY']).tap do |statsd|
    statsd.namespace = "education.#{Rails.env}.rails"
  end

  EducationStats.configure do |config|
    config.hosted_graphite_api_key   = 'abc123'
    config.hosted_graphite_namespace = 'rails.requests'
    config.add_statsd_client(other_client)
  end
```

Grab the client and send some commands:

```ruby
  client = EducationStats.client

  client.increment 'education.mymetric'
  client.time 'education.my_timer' do
    @app.expensive_call()
  end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'education_stats'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install education_stats

## Development

After checking out the repo, run `script/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `script/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mkcode/education_stats.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

