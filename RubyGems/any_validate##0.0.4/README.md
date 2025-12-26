# Any::Validate

Validate the various things.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'any-validate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install any-validate

## Usage

```
require 'any/validate'

class Hoge
  include Any::Validate

  valid_ipaddress? ip: '128.0.0.1' #=> true
  valid_ipaddress? ip: '255.255.255.2555' #=> false

  valid_macaddress? mac: 'B4:B5:2F:63:0F:7C' #=> true
  valid_macaddress? mac: 'B4:B5:2F:63:0F:7G' #=> false

  valid_uuid? uuid: 'FEAAF64D-6132-44DD-8779-C2E297B622B5' #=> true
  valid_uuid? uuid: 'FEAAF64D-6132-44DD-8779-C2E297B622B51' #=> false
end
```

## Contributing

1. Fork it ( https://github.com/youyo/any-validate/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
