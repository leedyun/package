# Advisors Command Client

A small gem to use AdvisorsCommand in a ruby application.

* Full support for WSSE authentication.
* Simple Virtus POROs for models.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'advisors_command'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install advisors_command

## Usage

Create a client:
```ruby
  $advisors_client = AdvisorsCommandClient::Client.new(username, api_key)
```

### Contacts
Find contacts, returns a collection of `Model::Contact`
```ruby
  $advisors_client.contacts.search("Bob")
```

Find a single contact, returns a `Model::Contact`
```ruby
  $advisors_client.contacts.find(1234)
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/RepPro/advisors_command/fork )
2. Create your feature branch (`git checkout -b f/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin f/my-new-feature`)
5. Create a new Pull Request
