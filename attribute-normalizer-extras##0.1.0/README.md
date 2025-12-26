# AttributeNormalizer::Extras

Extra normalizers for the [attribute_normalizer](https://rubygems.org/gems/attribute_normalizer) gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'attribute_normalizer-extras'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attribute_normalizer-extras

## Usage

    class Foo < ActiveRecord::Base
      normalize_attribute :postal_code, with: :postal_code
      normalize_attribute :email, with: :gsub, pattern: /(googlemail.com)/, replacement: "gmail.com"
      normalize_attribute :country_abbreviation, with: :spaceless
    end

## Contributing

1. Fork it ( https://github.com/[my-github-username]/attribute_normalizer-extras/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
