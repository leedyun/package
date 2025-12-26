# Alerty::Plugin::DatadogEvent

Datadog Event plugin for [alerty](https://github.com/sonots/alerty).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alerty-plugin-datadog_event'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alerty-plugin-datadog_event

## Configuration

following is required.

- **type** : must be datadog_event
- **api_key** : Datadog API Key 
- **subject** : subject of alert. ${command} is replaced with a given command, ${hostname} is replaced with the hostname ran a command
- **alert_type** : "error", "warning", "info" or "success". See [Datadog API Document](http://docs.datadoghq.com/ja/api/#events).

following is an example.

```
log_path: STDOUT
log_level: 'debug'
timeout: 10
lock_path: /tmp/lock
plugins:
  - type: datadog_event
    api_key: API Key
    subject: "FAILURE [${hostname}] : ${command}"
    alert_type: error
```

See [examle.yml](https://github.com/inokappa/alerty-plugin-datadog_event/blob/master/example.yml).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/alerty-plugin-datadog_event.

