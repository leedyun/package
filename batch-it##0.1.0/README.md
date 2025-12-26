# BatchIt

Quick and dirty (possibly batch) processing of .markdown.erb files.

## Installation

Add this line to your application's Gemfile:

    gem 'batch_it'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install batch_it

## Usage

```ruby
require 'batch_it'
require 'ostruct'

puts BatchIt.new(DATA.read).result([OpenStruct.new(title: "One"), OpenStruct.new(title: "Two")])
__END__
<%= title %>
=
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
