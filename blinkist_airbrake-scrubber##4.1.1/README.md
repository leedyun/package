# Blinkist::AirbrakeScrubber

Blinkist::AirbrakeScrubber provides an Airbrake scrubbing service to remove various sensitive informations from the notifications, e.g. emails. It does *not* replace Airbrake configuration, but provides some seamless functionality.

## Installation

Add this line to your application's Gemfile:

    gem "blinkist-airbrake-scrubber"

And then execute:

    $ bundle install

## Information

### Extending the functionality

To extend the functionality, create a new scrubber file in `lib/blinkist-airbrake-scrubber/scrubbers` folder, like the template:

```ruby
module Blinkist::AirbrakeScrubber
  class WubbaLubba
    REGEXP = /[\S]+@[\S]+/i

    def self.scrub!
      ::Airbrake.add_filter do |notice|
        # Rainbows and unicorns come here:
        notice[:errors].each { |error| error[:message].gsub!(REGEXP, FILTERED) }
      end
    end # def self.scrub!

  end
end
```

Then, add the class to Blinkist::AirbrakeScrubber's SCRUBBERS list to have it ran after Airbrake.configure

### Dependencies

This gem has dependency on airbrake (~> 7), it will automatically add it unless already bundled.

## Maintainers

* Paweł Komarnicki (https://github.com/pawelkomarnicki)

## Special thanks

* Tomek Przedmojski (https://github.com/tprzedmojski) for providing a brilliant way to use Module#prepend :-)

## License

Copyright 2018 Blinks Labs GmbH. http://blinkist.com
