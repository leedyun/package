# activemodel-base64_validator

[![Build Status](https://travis-ci.org/increments/activemodel-base64_validator.svg?branch=master)](https://travis-ci.org/increments/activemodel-base64_validator)

## Usage

Add to your Gemfile:

```rb
gem 'activemodel-base64_validator'
```

Run:

```
bundle install
```

Then add the following to your model:

```rb
validates :my_base64_attribute, base64: true
```

## Validation outside a model

If you need to validate a base64 outside a model, you can get the regexp:

```rb
Base64Validator::REGEXP
Base64Validator.valid?(string)  # true or false
```

## Credit

Regular Expression based on http://stackoverflow.com/a/475217/1297336
