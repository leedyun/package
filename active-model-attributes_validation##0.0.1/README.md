# ActiveModel::AttributesValidation

Add `attributes_valid?` method in your model to validate a specific attribute/attributes. Can be easily used with ActiveRecord.

## Installation

Add this line to your application's Gemfile:

    gem 'active_model-attributes_validation'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_model-attributes_validation

## Usage

You can include it:
```ruby
class Model
  include ActiveModel::Model
  include ActiveModel::AttributesValidation
end
```
For ActiveRecord it will be loaded automatically.

Example:
```ruby
class Person
  include ActiveModel::Model
  include ActiveModel::AttributesValidation

  attr_accessor :name, :age
  validates_presence_of :name
  validates_presence_of :age
end

person = Person.new
person.attributes_valid?(:name) # => false
person.errors.messages # => {:name=>["can't be blank"]}

person.attributes_valid?(:name, :age) # => false
person.errors.messages # => {:name=>["can't be blank"], :age=>["can't be blank"]}

# standard full validation
person.valid? # => false
person.errors.messages # => {:name=>["can't be blank"], :age=>["can't be blank"]}

person.name = 'bill'
person.attributes_valid?(:name) # => true
person.errors.messages # => {}
```
See specs for more information.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
