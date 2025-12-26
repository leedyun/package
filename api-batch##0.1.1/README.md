# ApiBatch

Welcome to ApiBatch!

ApiBatch adds a BatchController to your api that allows multiple api requests to be sent to your api within a single http request saving round trips to the server.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'api_batch'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install api_batch

## Usage

Once the gem has been installed a controller will have been added to the following route:

    /batch

batch requests are sent to the server through a query string parameter array:

paths[]=........

Example:

    http://[host]/batch?paths[]=/countries/id/1&paths[]=/countrygroups/id/2

The above batch request would send 2 requests to the server for processing:

- /countries/id/1
- /countrygroups/id/2

These 2 request will be passed to the appropriate controllers and processed on the server as if they had bee sent as individual requests. The response from the batch request will return an array of the responses from each request specified in the paths[] array parameter in the order they were specified in the request.

> Example:
> [{response to /countries/id/1}, {response to /countrygroups/id/2}]

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/api_batch. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

