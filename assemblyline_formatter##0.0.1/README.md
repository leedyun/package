# Assemblyline::Formatter

A backport of example level run time from the Json formatter in Rspec 3.
This works in 2.14.7, and may or may not work in any other version of Rspec.

Assemblyline can use this output to balance parallel tests.
Remember that past performance is no indicator of future something.

## Installation

Add this line to your application's Gemfile:

    gem 'assemblyline-formatter'


And add this to your .rspec file

    --format AssemblylineFormatter
    --out al.json


## Contributing

1. Fork it ( http://github.com/assemblyline/assemblyline-formatter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
