# ApplicationDigester

Disclaimer: This library is still in early stages of development.

This gem is intended to be used with a rails application, and has a dependency
on `Rails.root`. By default, files in `log` and `tmp` are excluded in digesting.

Having a digest of the application running files is useful to know what code is
actually running. Typically, a git SHA will be superior to calculating your own
digest from the files for at least one major reason: You can quickly access the
exact version of code running in git using the SHA. However, depending on the
setup of your environment you might not have access to the git repo. This is
where `ApplicationDigester` is useful.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'application_digester'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install application_digester

## Usage

For now:
`ApplicationDigester.new.digest`


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/schneiderderek/application_digester. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

