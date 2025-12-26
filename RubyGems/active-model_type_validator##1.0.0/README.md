# ActiveModelTypeValidator

Provides two ActiveModel validators:

1. One to validate that an attribute is of the correct type. Multiple types are allowed.
2. One to validate the contents of an attribute by calling `#valid?` on it, performing
   the same job as ActiveRecord's `validates_associated`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_model_type_validator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_model_type_validator

## Usage

The usage is fairly standard. The `object_type` validator takes one option `:type` which
is either a type name (string, symbol or type) or an array of type names. The `contents`
validator needs no options. Both take the standard options all validators do, except
that `object_type` ignores the `:allow_blank` option (you should use `:allow_nil` if you
need equivalent behavior).

Examples:

```ruby
class MyClass
    include ActiveModel::Model
    include ActiveModel::Validations

    validates :string_field, object_type: { type: String }
    validates :integer_field, object_type: { type: Integer }
    validates :numeric_field, object_type: { type: [Integer, Float] }
    validates :object_field, contents: true, object_type: { type: ChildClass }

    attr_accessor :string_field
    attr_accessor :integer_field
    attr_accessor :numeric_field
    attr_accessor :object_field

    def initialize
        @string_field = 'my string'
        @integer_field = 42
        @numeric_field = 7
        @object_field = ChildClass.new
    end

end
```

The `contents` validator adds what's equivalent to ActiveModel's `associated` validator,
passing if calling `#valid?` on the attribute returns true.
  
The `object_type` validator lets you test ActiveModel objects used in an API to make sure
they contain objects of the expected types rather than something you aren't expecting. It
fills in a gap I was annoyed by when I validate incoming API objects immediately upon
receiving them and go no further if they fail validation.

## Contributing

1. Fork it ( https://github.com/tknarr/active_model_type_validator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
