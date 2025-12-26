# Acme::Bleach

A silly gem that cleans your source file.

## Installation

Just install it yourself as:

    $ gem install acme-bleach

## Usage

Require this gem and the first time you run your script your file will be
cleaned of all the messy things like printable characters.  The next time it
will still run as usual, but without any visible code.

    require 'acme/bleach'

NB: this should be in a `.rb` script that you're going to run.  This is not a
gem for Rails or to be included in another gem.

## Acknowledgements

Damian Conway for the [original Perl version](http://search.cpan.org/~dconway/Acme-Bleach-1.150/lib/Acme/Bleach.pm) from which I stole liberally.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
