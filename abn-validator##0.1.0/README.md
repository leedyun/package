AbnValidator
============

Super simple Rails validator for checking the validity of ABNs

[Format of the ABN | Australian Taxation Office](https://www.ato.gov.au/Business/Australian-business-number/In-detail/Introduction/Format-of-the-ABN/)

Installation
------------

Add this line to your application's Gemfile:

```
gem 'abn_validator'
```

```
$ bundle
```

Usage
-----

### With ActiveRecord

```
class Business < ActiveRecord::Base
  validates :abn, abn: true
end
```

### i18n

```
en:
  errors:
    messages:
      invalid_abn: 'Invalid ABN'
      invalid_abn_length: 'Invalid ABN Length'
```

Contributing
------------

1. Fork it ( https://github.com/wonderbread/abn_validator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
