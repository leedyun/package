# AbbreviatedMethods - Call your object's methods by theirs abbreviations

**If you include 'AbbreviatedMethods' in your objects you can call their's methods by all their possible abbreviations.**

[![asciicast](https://asciinema.org/a/34559.png)](https://asciinema.org/a/34559)

## How to call your methods by their abbreviations

```ruby
require 'abbreviated_methods'

class Dog
  include AbbreviatedMethods

  def name
    'Fred'
  end
end

dog = Dog.new

dog.name => 'Fred'
dog.nam => 'Fred'
dog.na => 'Fred'
```

## About

Did you know about [Abbrev](http://ruby-doc.org/stdlib-2.3.0/libdoc/abbrev/rdoc/Abbrev.html) class in Ruby's standard library? I discovered it while browsing through ruby docu. I think it's so cool but i couldn't think about any useful use-case other than CLIs in the moment so i just tried to play a bit with it here. If you know some valid usecase please let me know!

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

