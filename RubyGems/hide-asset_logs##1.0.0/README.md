# Hide Asset Logs

Stop asset requests from being logged in your terminal.

Thanks to [@macournoyer](https://github.com/macournoyer) for [the original code](https://github.com/rails/rails/issues/2639#issuecomment-6591735).

## Installation

Add this line to your application's `Gemfile`, in the `:development` group:

    group :development do
      gem 'hide_asset_logs'
    end

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hide_asset_logs

## Usage

Just add it your `Gemfile`, and you're done! Note that this gem will always be disabled in production.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
