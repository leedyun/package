# @author Todd Knarr <tknarr@silverglass.org>

# ActiveModelSerializerPlus

Enhances the standard ActiveModel::Serializers::JSON and ActiveModel::Serializers::Xml
modules by adding a default `#attributes=` method that implements the normal loop used to
assign values to attributes. The loop makes use of the `#attribute_types` hash to convert
sub-hashes to objects of the right class and to parse strings into values of the right
type (eg. to insure a string containing a time value is converted into a Time object).
This allows for automatic deserialization of serialized objects without needing to write
code for it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_model_serializer_plus'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_model_serializer_plus

## Usage

Add the gem's module to your source file:

```ruby
require 'active_model_serializer_plus`
```

Then in the class you need to serialize/deserialize you include the Assignment module
after including all of the ActiveModel modules you need:

```ruby
include ActiveModelSerializerPlus::Assignment
```

The `#attributes=` method this module provides will raise an `ArgumentError` with a
descriptive message if a problem occurs.

The class will need to implement the `#attribute_types` method which should return a hash
consisting of attribute names and the name of the type/class of the attribute. You only need
to include those attributes that are themselves a serializable class and that you want turned
back into objects rather than being left as hashes, or attributes that aren't automatically
converted from strings back into the correct type (eg. Date, Time, DateTime).

The value can be a string, symbol or class name to specify the type. For containers (arrays or
hashes) it is a 2-element array with the first element being the type of the container (array
or hash) and the second element specifying the type of the elements in the container. You can
also specify the type of the container as just `'Container'` or `:Container` and the code will
create a container of the same type (array or hash) as occurs in the JSON. Due to the fact that
the JSON doesn't indicate the type of elements in a container there's no straightforward way to
have containers contain elements of different types. It's also not possible to declare a container
whose elements are containers, elements have to be of a non-container class.

This would be an example:

```ruby
require 'active_model_serializer_plus'

class Example
    include ActiveModel::Model
    include ActiveModel::Serializers::JSON
    include ActiveModelSerializerPlus::Assignment
    
    attr_accessor :integer_field
    attr_accessor :time_field
    attr_accessor :string_field
    attr_accessor :object_field
    attr_accessor :array_field
    
    def attributes
    {
        'integer_field' => nil,
        'time_field' => nil,
        'string_field' => nil,
        'object_field' => nil,
        'array_field' => nil
    }
    
    def attribute_types
    {
        'time_field' => 'Time',
        'object_field' => 'SomeSerializableClass',
        'array_field' => [ 'Array', 'Integer' ]
    }
    
    def initialize( i, t, s, o )
    {
        integer_field = i
        time_field = t
        string_field = s
        object_field = o
        array_field = [ 1, 2, 3, 4, 5 ]
    }
    
end
```

Examples of using this class to serialize an object to a JSON string:

    obj = Example.new( 5, Time.now, 'xyzzy abc', SomeSerializableClass.new )
    json_string = obj.to_json

json_string now contains:

    { "integer_field" => 5, "time_field" => "2015-09-26T19:04:07-07:00", "string_field" => "xyzzy abc",
      "object_field" => { ... }, "array_field" => [ 1, 2, 3, 4, 5 ] }

And deserializing that string back to an object:

    new_obj = Example.new.from_json( json_string )

new_obj should now be identical to obj, including having time_field being a Time object and
object_field being a SomeSerializableClass object initialized from the hash in 'object_field'.

For ActiveModel classes the types could have been included in the `#attributes` hash, but that would
conflict with the use of `#attributes` in ActiveRecord classes and could cause confusion.

## Adding information about new types

In the `translations.rb` file there are some functions defined on the ActiveModelSerializerPlus module
itself. The ones you'll probably find useful are `#add_xlate` and `#add_type` which add information about
a type to the hashes that control formatting and parsing. You'll need to read the documentation on the hashes
themselves for details, but the short form is that `#add_type` takes the name of a type/class, a Proc that
takes and object and formats it into a string, a Proc that takes a string and parses it and initializes an
object from it, and a Proc that takes a deserialized hash and constructs an object from it. `#add_xlate`
takes the name of a type and the name of it's pseudo-parent class and adds an entry to the type name
translation table. The lookup routines check for a translation first and see if Procs exist for the
translated name (the pseudo-parent type). Most of the time you'd omit any new translations and let the
lookup routines walk up the normal class inheritance chain to find the correct formatting and parsing Procs.
You'd only fill in translations if you had classes that can be treated as derived from a common class but
that don't actually derive from any common class. `TrueClass` and `FalseClass` are a good example. They don't
need a formatting class because they already serialize as `true` and `false` which is convenient, but you'll\
find a parsing Proc for the pseudo-class `Boolean` that correctly parses both of those strings back to true and
false values. To set this up you'd do:

```ruby
add_type('Boolean', nil, Proc.new { |boolean| %w(1 true).include?(boolean.to_s.strip.downcase) }, nil)
add_xlate('TrueClass', 'Boolean')
add_xlate('FalseClass', 'Boolean')
```

which would create the parsing proc entry for `Boolean` and add the translation entries so that `TrueClass`
and `FalseClass` act as if derived from an imaginary `Boolean` class for formatting and parsing purposes.

## Adding information about new containers

In `assignment.rb` there are some functions defined on the ActiveModelSerializersPlus module for adding
new containers. The basic one is `#add_container` which takes 3 arguments: the container type
name, a proc for iterating through elements from that kind of container and a proc for adding an item to
that kind of container. The procs paper over the differences in containers, without that there'd need to
be a separate bit of code for every permutation of source container in the JSON and new destination container.
The procs for Hash-like containers are the basis for the code. The iterator proc for an Array-like container
uses the array index as the key when calling the adder proc, and the adder proc for Array-like containers
ignores the key and just appends the new item to the array. I don't expect a need to add containers often,
and since most new containers will act like either Arrays or Hashes there are two convenience functions
`#add_arraylike_container` and `#add_hashlike_container` that take just the container type name and use
the matching standard iterator and adder procs.

## Contributing

This project uses `git-flow`, where new features are developed along feature branches based off the
`develop` branch rather than `master`. Avoid naming your branches `master`, `develop`, `hotfix-`* or `release-`*
as those conflict with standard branches for hotfixes and releases. You should fork and branch off of the
`develop` branch instead of `master`, and merge back to `develop` before creating your pull request.
