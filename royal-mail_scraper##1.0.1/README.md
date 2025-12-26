# RoyalMailScraper

[![Build Status](https://secure.travis-ci.org/laurynas/royal_mail_scraper.png)](http://travis-ci.org/laurynas/royal_mail_scraper)

A simple page scraper for Royal Mail Track and Trace.

## Installation

Add this line to your application's Gemfile:

    gem 'royal_mail_scraper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install royal_mail_scraper

## Usage

    tracker = RoyalMailScraper::Tracker.fetch('TRACKING_CODE')

    p tracker.status
    p tracker.message
    p tracker.details

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

This GEM is originally inspired by 
[PHP-Royal-Mail-Track-and-Trace](https://github.com/roldershaw/PHP-Royal-Mail-Track-and-Trace) script.


