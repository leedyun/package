# ArabicNormalizer

ArabicNormalizer is pure Ruby port of Arabic Normalizer from Lucene.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'arabic_normalizer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arabic_normalizer

## Usage
```
require 'arabic_normalizer'

ArabicNormalizer::normalize("مكتبٌ")
=> "مكتب"
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

