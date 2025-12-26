# ActAsNameable

[![Gem Version](https://badge.fury.io/rb/act_as_nameable.png)](http://badge.fury.io/rb/act_as_nameable)

*Add full name methods on a model*

## Usage

```ruby
class User < ActiveRecord::Base
  act_as_nameable
    with: [:first_name, :surname, :middle_name, :second_surname],
    required: [:first_name, :surname]
end
```

## Installation

Add `gem 'act_as_nameable'` to Gemfile, then:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install act_as_nameable
```

## Test

```shell
rake
```

## Contributing

1. Fork repository
2. Create a branch following a [successfull branching model](http://nvie.com/posts/a-successful-git-branching-model/)
3. Write your feature/fix
4. Pull request

## Licence

Released under the MIT License. See the [LICENSE](https://github.com/caedes/act_as_nameable/blob/master/LICENSE.md) file for further details.
