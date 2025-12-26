# CustomLogs

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'custom_logs', '0.0.4'

And then execute:

    $ bundle

Generate config file:

    $ rails g custom_logs or rails g custom_logs syslog


## Usage

You can log your users data with this command:

    $ bundle exec rake custom_logs:dump_users #for User class

    or

    $ bundle exec rake custom_logs:dump_users dump_class=Admin #for your custom class


TODO: Write usage instructions here

## Contributing

1. Fork it ( http://github.com/<my-github-username>/custom_logs/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
