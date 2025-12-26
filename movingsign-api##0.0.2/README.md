# MovingsignApi

MovingSign Communication Protocol V2.1 Implementation in Ruby to control
[compatible LED signs](http://www.signsdirect.com/Home/LED-Signs-Programmable/7x80-LED-Indoor-Brightness-Sign-Red.html).

## Installation

Add this line to your application's Gemfile:

    gem 'movingsign_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install movingsign_api

## Usage

Using the MovingsignApi is straight forward.

<!-- include spec/tutorials/readme_1.rb -->
``` ruby
require 'movingsign_api'

sign = MovingsignApi::Sign.new '/dev/ttyUSB0'

sign.show_text "Hello World"

```

There are other commands and quite a few options.  See [MovingsignApi::Sign](lib/movingsign_api/sign.rb) or [MovingsignApi::Command](lib/movingsign_api/commands/command.rb) and it's subclasses.

## Versions

A complete version history is in [CHANGELOG.md](CHANGELOG.md).

## Todo

Not all of the Movingsign protocol is implemented.  Some of missing functionality include:

* Text formatting isn't supported
* Graphics commands aren't supported
* Some write control commands are not implemented:
  * Set/Change password
  * Set/Change device address
  * Changing the text file display mode
* Read control commands
  * Read clock
  * Read equipment attributes

## Contributing

Make a pull request and be sure to include test cases!

## Other Projects

* [multi_movingsign](https://github.com/webmonarch/multi_movingsign) - to drive multiple Movingsigns at the same time for an information display board