# Alephant::Logger::Statsd

Statsd driver for the [alephant-logger](https://github.com/BBC-News/alephant-logger) gem, which consumes the [statsd-ruby](https://github.com/reinh/statsd) gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alephant-logger-statsd'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alephant-logger-statsd

## Usage

Create an instance of the driver:

```ruby
require "alephant/logger"
require "alephant/logger/statsd"

config = {
  :host      => "statsd.test.service.bbc.co.uk",
  :port      => 6452,
  :namespace => "test"
}

driver = Alephant::Logger::Statsd.new config
logger = Alephant::Logger.setup driver
logger.increment "foo.bar"
```

**Note** that a config is *optional*, if you leave any of the keys out then they will be replaced by the following:

```ruby
{
  :host      => "localhost",
  :port      => 8125,
  :namespace => "statsd"
}
```

Then increment a custom metric, with a given key:

```key
driver.increment 'front_page.response_time'
```

You can also increment the metric by a specific interval:

```key
driver.increment('facebook.signups', 43)
```

## Contributing

1. [Fork it!](https://github.com/bbc-news/alephant-logger-statsd/fork)
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Create a new [Pull Request](https://github.com/BBC-News/alephant-logger-statsd/compare).

## Help

Please raise a new [issue](https://github.com/BBC-News/alephant-logger-statsd/issues/new) with the relevant label, or ping [@revett](http://github.com/revett).
