# Fluent::Plugin::HaproxyStats

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/fluent/plugin/haproxy_stats`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fluent-plugin-haproxy_stats'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-haproxy_stats

## Usage

### Configuration

#### HAProxy

- Require `stats` option

```
global
    stats socket /path/to/stats

defaults
    mode    http
    option  httplog
    option  httpclose
    retries 3
    option  redispatch
    maxconn 2000

frontend app1
  bind 0.0.0.0:10011
  default_backend app1

backend app1
  balance roundrobin
  server web1 127.0.0.1:10006
  server web2 127.0.0.1:10007
```

#### fluentd

```
<source>
  type haproxy_stats
  stats_file "/path/to/stats"
  px_name app1
  sv_name FRONTEND
  tag haproxy.input
</source>

<match haproxy.input.**>
  type stdout
</match>
```

## ToDo

- Test!!
- Multiple pxname and svname.
- and More...

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/fluent-plugin-haproxy_stats/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
