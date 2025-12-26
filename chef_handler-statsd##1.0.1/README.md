# Chef Handler Statsd

Chef Handler Statsd is an OpsCode Chef report/exception handler for sending
Chef metrics to a statsd compatible server. Metrics are gathered using
`run_status`.

## Installation

    gem install chef-handler-statsd

## Usage

Append the following to your Chef client configs, usually at `/etc/chef/client.rb`

```ruby
  require "chef-handler-statsd"

  handler = ChefHandlerStatsd.new('localhost', 8125)

  report_handlers << handler
  exception_handlers << handler
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
