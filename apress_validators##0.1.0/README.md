# Apress::Validators
<a href="http://dolly.railsc.ru/projects/136/builds/latest/?ref=master">
  <img src="http://dolly.railsc.ru/badges/abak-press/apress-validators/master" height="18">
</a>

Validators for ActiveRecord and ActiveModel.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'apress-validators'
```

And then execute:

    $ bundle install

## Available Validators

`CountValidator` - behaves similarly to `LengthValidator`, but designed only for associated records. Does not count records
that are marked for destruction. Takes the same options as `LengthValidator`.
```ruby
validates :image, :count => {:maximum => 24}
validates :image, :count => {:minimum => 2, message: 'Must have at lest 2 images'}
validates :image, :count => {:is => 3, :allow_nil => true}
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/apress-validators/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
