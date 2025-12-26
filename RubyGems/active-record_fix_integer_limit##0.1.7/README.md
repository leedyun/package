# ActiveRecord::FixIntegerLimit

ActiveModel::Type::Integer uses 4 bytes, but our databases use 8. So we
explicitly pass that limit of 8 to the appropriate ActiveRecord::Type
constructor and recalculate the range. Now, e.g., [Fabricate], won't complain
anymore that:

``` ruby
ActiveModel::RangeError:
  def initialize(*)
    6367829093 is out of range for ActiveModel::Type::Integer with limit 4 bytes
```

[Fabricate]: https://fabricationgem.org/

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record_fix_integer_limit'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install active_record_fix_integer_limit
```

## Test

You can test the gem with:
```bash
$ bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on Gitlab at
https://gitlab.com/incommon.cc/active_record_fix_integer_limit.

The [Github repository] is a mirror to facilitate integration with other Rails
development, but I don't like Microsoft, and never will. They may show the face
they like, they come from enemity and, as far as I'm concerned, will remain
there.

[Github repository]: https://github.com/moners/active_record_fix_integer_limit

# Development

After checking out the repo, run `bin/setup` to install dependencies.  
Run specifications with `bundle exec rake`.  

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).  
See `bundle exec rake -T` for more options.

## License

The gem is free software under the same [license] terms as Rails.

[license]: ./MIT-LICENSE
