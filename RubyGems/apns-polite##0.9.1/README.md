# ApnsPolite

Apple Push Notification Service

## Installation

Add this line to your application's Gemfile:

    gem 'apns_polite'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install apns_polite

## Usage

    m = ApnsPolite::Message.new 'device_token', alert: 'message sample', badge: 3
    n = ApnsPolite::Notification.new host: "gateway.push.apple.com", port: 2195, pem: "pem path", password: "pem password"
    
    n.push m
    
    n.close

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
