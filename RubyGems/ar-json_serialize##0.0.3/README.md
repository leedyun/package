# ActiveRecord Json Serialize
[![Coverage Status](https://coveralls.io/repos/dotpromo/ar_json_serialize/badge.png?branch=master)](https://coveralls.io/r/dotpromo/ar_json_serialize?branch=master)[![Build Status](https://travis-ci.org/dotpromo/ar_json_serialize.png?branch=master)](https://travis-ci.org/dotpromo/ar_json_serialize)[![Gem Version](https://badge.fury.io/rb/ar_json_serialize.png)](http://badge.fury.io/rb/ar_json_serialize)[![Code Climate](https://codeclimate.com/github/dotpromo/ar_json_serialize.png)](https://codeclimate.com/github/dotpromo/ar_json_serialize)

ActiveRecord JSON serializer

## Installation

Add this line to your application's Gemfile:

    gem 'ar_json_serialize'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ar_json_serialize

## Usage

You need to have some `text` field for storing some specific data in Hash/Array/etc inside you model.

Add next string in your ActiveRecord model:

```ruby
class Promo < ActiveRecord::Base
  json_serialize :test_column
end
```

You can set value of this column with any object.

```ruby
promo = ::Promo.new
promo.test_column = {'key1' => 'value1'}
promo.save!
```

And use it with full power of Hashie!

```ruby
promo = ::Promo.last
puts "Our value is #{promo.test_column.key1}"
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
