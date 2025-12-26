# Cinch::Plugins::Logsearch

Cinch Plugin to allow users to search through channel logs, easiest used with cinch-simplelog.

## Installation

Add this line to your application's Gemfile:

    gem 'cinch-logsearch'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cinch-logsearch

## Usage

Just add the plugin to your list:

    @bot = Cinch::Bot.new do
      configure do |c|
        c.plugins.plugins = [Cinch::Plugins::LogSearch]
      end
    end

If your logs are not in `logs/*.logs` you will need to set a config
value to point to the location of your logs.

    c.plugins.options[Cinch::Plugins::LogSearch][:log_path] = '/var/logs/irc/*.log'

You can also change the number of results returned (Default: 5) by setting an additional config value:

    c.plugins.options[Cinch::Plugins::LogSearch][:max_results] = 10

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
