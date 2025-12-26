# AcceptsNestedSerializedAttributes

Writing an API? Serializing your objects between Rails powered apps? Want to use nested associations without writing extra (de)serialization code? Want to get away with just using `ActiveModel#as_json`? Do your models declare `accepts_nested_attributes_for`?

You might have noticed how calling `@model.as_json include: :association` will return a hash that includes the association but the name isn't suffixed with `_attributes` which `accepts_nested_attributes_for` needs in order to build the association from those nested attributes. Well, the API consumer could worry about it, but what if the API consumer is another Rails app? Why not make it as easy as possible for them and just send the association through with the correct key so they can just use `Model.new.from_json params[:model]` and have ActiveModel build the associations automatically given that they declare `accepts_nested_attributes_for :association`? 

This tiny gem is the answer. It monkey patches `ActiveModel::Serialization#serializable_hash` and renames nested attributes keys if they are declared as such via `accepts_nested_attributes_for` in the given model.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'accepts_nested_serialized_attributes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install accepts_nested_serialized_attributes

## Usage

Adding the Gem to your Gemfile is enough to make this work. Given:

```ruby
class Model < ActiveRecord::Base
  has_many :associations
  accepts_nested_attributes_for :associations
end
```

Then:

```ruby
@model = Model.first
@model.as_json include: :associations
```

Will return:

```ruby
{
  id: 1
  associations_attributes: {
    attribute_1: 'value'
  }
}
```

If you don't declare `accepts_nested_attributes_for` then the attributes won't be renamed in the serialized hash.

Only the API producer needs this Gem, the consumer just needs to declare `accepts_nested_attributes_for` and they can just:

```ruby
@model = Model.new.from_json params[:model]
```

And the association will be built automatically as you'd expect.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/accepts_nested_serialized_attributes/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
