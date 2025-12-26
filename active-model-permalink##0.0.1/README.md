# ActiveModel::Permalink

`ActiveModel::Permalink` generates permalinks for your `ActiveModel` objects. It includes support for `Mongoid`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_model-permalink'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_model-permalink

## Usage

`ActiveModel::Permalink` generates permalinks for your objects as part of a `before_validation` callback. It uses the following attributes in order to generate from (provided these are present):

* name
* title

In case the `permalink` attribute is present already, it won't bother to change it. See [the specs](https://github.com/liquid/active_model-permalink/blob/master/spec/lib/active_model/permalink_spec.rb) for more information about the behavior.

### With simple ActiveModel classes

```ruby
class MyClass
  # Make sure you are using a real ActiveModel object
  extend ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  include ActiveModel::Permalink

  attr_accessor :name, :title, :permalink
end

my_instance = MyClass.new
my_instance.name = 'My Name'

my_instance.valid? # this triggers the callback that is used to ensure a permalink is present
my_instance.permalink
# => 'my-name'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
