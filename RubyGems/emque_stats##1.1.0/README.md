[![Build Status](https://travis-ci.org/emque/emque-stats.png)](https://travis-ci.org/emque/emque-stats)

# Emque Stats

A library that provides any [Emque::Producing](https://github.com/emque/emque-producing)
application instrumentation capabilities for collecting application statistics
and events. Stats and events are sent as just another Emque message through the
Message Broker (RabbitMQ).

A separate [Emque::Consuming](https://github.com/emque/emque-consuming)
service must be created and deployed to process the data. In doing so, you can
use your preferred graphing or analytics solution, be it Graphite, StatsD,
New Relic, Keen.io, etc.

## Installation

Add this line to your application's Gemfile:

    gem 'emque-stats'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install emque-stats

## Usage

For any app already using Emque::Producing, there is nothing further to do.
Emque::Stats will re-use the same configuration.

For an app that is not already using Emque::Producing.

``` ruby
  Emque::Stats.configure do |config|
    emque_configuration = Emque::Producing::Configuration.new
    emque_configuration.app_name = "your_app"
    emque_configuration.rabbitmq_options = { :url => "your rabbitmq url" }
    config.emque_producing_configuration = emque_configuration
  end
```

Send some stats

``` ruby
  # track activity
  Emque::Stats.track("login", {:user_id => 1, :another_property => "something"} )

  # counter
  Emque::Stats.increment("garets")
  Emque::Stats.count("garets", 20)

  # timing
  Emque::Stats.timer("glork", 320)

  # gauge
  Emque::Stats.gauge("bork", 100)
```

## Tests

To run tests...

```
bundle exec rspec
```

## Contributing

FIRST: Read our style guides at
https://github.com/teamsnap/guides/tree/master/ruby

1. Fork it ( http://github.com/emque/emque-stats/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
