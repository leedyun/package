# Acception::Subscriber

A RabbitMQ subscriber that pushes messages to Acception's API.


## Installation

Add this line to your application's Gemfile:

    gem 'acception-subscriber'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acception-subscriber

## Usage

The acception-sub service is init.d compliant with the start, stop and restart commands.

### Start the acception-sub service in daemon mode.

    $ acception-sub start

### Start the acception-sub service in interactive mode with a DEBUG log level.

    $ acception-sub start -i -o debug

### Start the acception-sub service in a Rails environment other than production.

    $ RAILS_ENV=development acception-sub start


### Configuration File

A configuration file that defaults to /etc/ncite/acception-sub.conf can be used to override the 
default configuration.  The configuration file is a JSON object literal.

    {
      "acception_url": "some/url",
      "acception_auth_token": "some-auth-token",
      "host_uri": "amqp://guest:guest@127.0.0.1:5672",
      "queue": "some-queue-name'
    }

You can specify a different configuration file to use with -c or --config.

    $ acception-sub start -c /some/path/to/config


### Default Files

- /etc/ncite/acception-sub.conf
- /var/log/ncite/acception-sub.log
- /var/run/ncite/acception-sub.conf
