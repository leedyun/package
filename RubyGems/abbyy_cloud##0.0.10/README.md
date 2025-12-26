# [WIP] ABBYY::Cloud

[![Gem Version](https://img.shields.io/gem/v/abbyy-cloud.svg?style=flat)][gem]
[![Build Status](https://img.shields.io/travis/nepalez/abbyy-cloud/master.svg?style=flat)][travis]
[![Dependency Status](https://img.shields.io/gemnasium/nepalez/abbyy-cloud.svg?style=flat)][gemnasium]
[![Code Climate](https://img.shields.io/codeclimate/github/nepalez/abbyy-cloud.svg?style=flat)][codeclimate]
[![Inline docs](http://inch-ci.org/github/nepalez/abbyy-cloud.svg)][inch]

JSON HTTP client to the [ABBYY Cloud API][abbyy-api].

## Setup

The library is available as a gem `abbyy-cloud`.

## Usage

Initialize the client with a corresponding credentials:

```ruby
require "abbyy/cloud"

CLIENT = ABBYY::Cloud.new(id: "foo", token: "bar")
```

You can set these options explicitly:

```ruby
CLIENT = ABBYY::Cloud.new id:      "foo",
                          token:   "bar",
                          engine:  "Sandbox" # default engine for translations
```

And then use the client to provide requests:

```ruby
res = CLIENT.mt.translate("To be or not to be", from: :en, to: :ru)
res.translation  # => "Быть или не быть"

res = CLIENT.mt.translate_segments ["To be or not to be", "That is the question"], from: "en", to: "ru"
res.map(&:text) # => ["Быть или не быть", "Это вопрос"]
```

## Namespaces and Operations

### Machine Translations

The namespace `mt` contains (synchronous) operations with machine translation.

#### engines

See [the specification](https://api.abbyy.cloud/swagger/ui/index#!/MachineTranslation)

```ruby
result = CLIENT.mt.engines
# => [#<ABBYY::Cloud::Models::Engine @name="Sandbox">]
```

#### engine

This operation is built on top of the previous one and simply takes settings for the specified engine:

```ruby
result = CLIENT.mt.engine("Sandbox")

result.class                  # => ABBYY::Cloud::Models::Engine
result.name                   # => "Sandbox"
result.languages              # => ["en", "ru"]
result.translation_directions # => [#<ABBYY::Cloud::Models::Direction source: "en", target: "ru">]
result.to_h
# => { name: "Sandbox", languages: ["en", "ru"], translation_directions: [{ source: "en", target: "ru" }] }
```

#### default_engine

Returns settings for the engine used in the initializer

```ruby
CLIENT = ABBYY::Cloud.new(id: "foo", token: "bar", engine: "Bing")

settings_for_bing = CLIENT.mt.default_engine
```

#### translate

Translates a string.

See [the specification](https://api.abbyy.cloud/swagger/ui/index#!/Order/Order_Translate).

```ruby
result = CLIENT.mt.translate("To be or not to be", from: :en, to: :ru)

result.class       # => ABBYY::Cloud::Models::Translation
result.translation # => "Быть или не быть"
result.id          # => "2832934"
result.to_h        # => { id: "2832934", translation: "Быть или не быть" }
```

#### translate_segments

Translates an array of strings in one request

See [the specification](https://api.abbyy.cloud/swagger/ui/index#!/Order/Order_TranslateSegments)

```ruby
result = CLIENT.mt.translate_segments(["To be", "or not to be"], from: :en, to: :ru)

result.class       # => ABBYY::Cloud::Models::TranslationSequence
result.map(&:text) # => ["Быть", "или не быть"]
```

### Files

The namespace `files` contains operations with <uploaded> files.

#### upload

Uploads a file

See [the specification](https://api.abbyy.cloud/swagger/ui/index#!/File/File_UploadFile)

```ruby
file   = File.read("file_to_upload.xml")
result = CLIENT.files.upload file
result.id    # => "18323"
result.token # => "foobarbaz"
#  ...
```

#### download

Dowloads a file by id and token

See [the specification](https://api.abbyy.cloud/swagger/ui/index#!/File/File_DownloadFile)

```ruby
result = CLIENT.files.download(id: "foo", token: "bar")
# => #<StringIO ...>
```

### Prices

The namespace `prices` contains operations with prices details.

#### details

See [the specification](https://api.abbyy.cloud/swagger/ui/index#!/Prices/Prices_GetAccountPrices).

```ruby
list = CLIENT.prices.details

list.first.to_h
# {
#   id:          "foo",
#   account_id:  "bar",
#   type:        "qux",
#   from:        "ru",
#   to:          "en",
#   unit_prices: [{ unit_type: "Words", currency: "USD", amount: 0.03 }],
#   discounts:   [{ discount_type: "TMTextMatch", discount: 0.01 }],
#   created:     Time.now
# }

```

The number of items can be several thousands. You can specify `skip` and `take` options to take necessary items only, otherwise it will return all prices.

Notice, though, that every single request can return no more than 1000 items. If you request more prices, several requests will be made one-by-one. Parsing all the results can be pretty slow.

## Compatibility

[WIP] Compatible to [ABBYY Cloud API v.0][abbyy-api].

Tested under [rubies compatible to MRI 2.3+][rubies] using [RSpec][rspec] 3.0+.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[abbyy-api]: https://api.abbyy.cloud/swagger/ui/index
[codeclimate]: https://codeclimate.com/github/nepalez/abbyy-cloud
[gem]: https://rubygems.org/gems/abbyy-cloud
[gemnasium]: https://gemnasium.com/nepalez/abbyy-cloud
[github]: https://github.com/nepalez/abbyy-cloud
[inch]: https://inch-ci.org/github/nepalez/abbyy-cloud
[rspec]: http://rspec.info/
[rubies]: .travis.yml
[travis]: https://travis-ci.org/nepalez/abbyy-cloud
