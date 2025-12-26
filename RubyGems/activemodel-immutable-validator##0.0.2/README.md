# activemodel-immutable_validator

[![Build Status](https://travis-ci.org/yuku-t/activemodel-immutable_validator.svg?branch=master)](https://travis-ci.org/yuku-t/activemodel-immutable_validator) [![Code Climate](https://codeclimate.com/github/yuku-t/activemodel-immutable_validator/badges/gpa.svg)](https://codeclimate.com/github/yuku-t/activemodel-immutable_validator) [![Coverage Status](https://coveralls.io/repos/yuku-t/activemodel-immutable_validator/badge.svg)](https://coveralls.io/r/yuku-t/activemodel-immutable_validator)

Validate immutable attributes.

## Usage

Add to your Gemfile:

```rb
gem 'activemodel-immutable_validator'
```

Run:

```
bundle install
```

Then add the followng to your model which belongs to a user:

```rb
validates :attr, immutable: true
```

### Sample

A human cannot become a bot vice versa.

```rb
class User < ActiveRecord::Base
  validated :type, immutable: true
end

class Bot < User
end

class Human < User
end
```
