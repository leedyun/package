[![Gem Version](https://badge.fury.io/rb/agnostic-duplicate.svg)](http://badge.fury.io/rb/agnostic-duplicate)
[![Build Status](https://travis-ci.org/dsaenztagarro/agnostic-duplicate.png)](https://travis-ci.org/dsaenztagarro/agnostic-duplicate)
[![Code Climate](https://codeclimate.com/github/dsaenztagarro/agnostic-duplicate/badges/gpa.svg)](https://codeclimate.com/github/dsaenztagarro/agnostic-duplicate)
[![Coverage Status](https://coveralls.io/repos/dsaenztagarro/agnostic-duplicate/badge.png?branch=master)](https://coveralls.io/r/dsaenztagarro/agnostic-duplicate?branch=master)
[![Dependency Status](https://gemnasium.com/dsaenztagarro/agnostic-duplicate.svg)](https://gemnasium.com/dsaenztagarro/agnostic-duplicate)

# Agnostic::Duplicate

Duplicate objects are provided with an additional method `duplicate` that
extends the method `dup` functionality, allowing deep copy or shallow copy of
specific fields.

## When to use

The advantage of using Duplicate module reside in support for fields that
are not duplicated by default for any reason by calling `dup`. Example: when 
using Rails `dup` implementation doesn't copy attributes of model that return an
ActiveRecord::Relation, it is supossed the developer to choose his strategy.

## Installation

Add this line to your application's Gemfile:

    gem 'agnostic-duplicate'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install agnostic-duplicate

## Usage

When using `Duplicate` you specify a list of attributes that you want to be
copied additionaly to the object returned by `dup`. Though if `dup` returns
a value for an attribute and you mark that attribute as "duplicable" then
the value of the attribute will be overwritten with the value provided by
`duplicate` call.

Example:

```ruby
 class Story < ActiveRecord::Base
   include Duplicate
   # ...
   attr_duplicable :seo_element, :category, :properties
   # ...
   attr_accessible :title
   # ...
   has_one :seo_element, as: :metadatable
   has_one :category, through: :categorisation, source: :category
   has_many :properties, :images, :headlines
   # ...
 end
```

When using `duplicable` over any attribute, it verifies if the current value
value implements `Duplicate`. In that case it returns the result of calling
to `duplicate` on that object. If the attribute doesn't implement
`Duplicate` it is returned the `dup` value.

If the `duplicable` attribute is iterable then it is returned an array where
every element of the collection is duplicated following the flow defined
previously.

Also it is possible to provide **shallow copies** of attribute values,
modifying the default behaviour. In that case, just make use of the
`strategy` option.

```ruby
  attr_duplicable :images, strategy: :shallow_copy
```

It is given support for custom behaviour after duplication process. In that
case it is only required to implement the method `hook_after_duplicate!`

Extending previous example:

```ruby
 def hook_after_duplicate!(duplicate)
   duplicate.headlines = self.headlines.not_orphans.collect(&:dup)
   duplicate.images.each { |img| img.attachable = duplicate }
 end
```

**ATENTION:** Observe that `model` passed as parameter is in fact the
duplicated instance that it is going to be returned

## Configuration options

If the only attribute values you want to be duplicated are the ones you have
specified through the `attr_duplicable` method, and though removing the
additional fields duplicated because of the init call to `dup`, then you can
set this configuration through `duplicable_config` method:

```ruby
 class Image < ActiveRecord::Base
   include Duplicate
   duplicable_config new_instance: true
   # ...
   attr_duplicable :images
   # ...
 end
```

If you want to apply the `duplicate` over a custom instance object instead
of the default template for the current configuration, then you can pass a
`dup_template` option on the method call

```ruby
otherobject  # => Object sharing duplicable attributes with 'myobject'
myobject.duplicate dup_template: otherobject
```

As the object passed to dup_template should be compliant with the duplicable
attribute list, if there is an error during the process an exception will
be raise according to the type of error:

  - Agnostic::Duplicate::ChangeSet::AttributeNotFound
  - Agnostic::Duplicate::ChangeSet::CopyError


## Contributing

1. Fork it ( https://github.com/dsaenztagarro/agnostic-duplicate/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
