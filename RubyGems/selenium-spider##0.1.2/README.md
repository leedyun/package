[![Gem Version](https://badge.fury.io/rb/selenium_spider.svg)](https://badge.fury.io/rb/selenium_spider)
[![Build Status](https://travis-ci.org/acro5piano/selenium_spider.svg?branch=master)](https://travis-ci.org/acro5piano/selenium_spider)

# Selenium Spider

Scrape websites using Firefox headlessly handled by Selenium.

This will have these features:

### Full JavaScript support

Based on Selenium Standalone DSL which run Firefox headlessly, it comprehences JavaScript completely.

### MPC architecture

MPC = Model Pagination Controller

Generally, scraping is consist of two parts: Listing page and Detail page.

In MPC architecture, Model is for extracting information from detail page and store data to database.

Pagination is for listing items and pagenation.

Controller is for handling the above two.

### Code generator

```sh
selenium-spider generate --site yahoo
#=> create app/models/yahoo.rb
#=> create app/paginations/yahoo_pagination.rb
#=> create app/controllers/yahoo_controller.rb
```

### Web-based task execution(Comming)

Scraping tasks are often multiply and difficult to arrange.

Imagine Web-based task execution, definition, csv-export and scheduling like Jenkins.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'selenium_spider'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install selenium_spider

## Usage

(Comming)

## Development

After checking out the repo, run `rake spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/acro5piano/selenium_spider. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

