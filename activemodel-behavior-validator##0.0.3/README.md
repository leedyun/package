# activemodel-behavior_validator

[![Build Status](https://travis-ci.org/increments/activemodel-behavior_validator.svg?branch=master)](https://travis-ci.org/increments/activemodel-behavior_validator) [![Code Climate](https://codeclimate.com/github/increments/activemodel-behavior_validator/badges/gpa.svg)](https://codeclimate.com/github/increments/activemodel-behavior_validator) [![Coverage Status](https://coveralls.io/repos/increments/activemodel-behavior_validator/badge.svg)](https://coveralls.io/r/increments/activemodel-behavior_validator) [![Dependency Status](https://gemnasium.com/increments/activemodel-behavior_validator.svg)](https://gemnasium.com/increments/activemodel-behavior_validator)

## Usage

Add to your Gemfile:

```rb
gem 'activemodel-behavior_validator'
```

Run:

```
bundle install
```

Then add the following to your model:

```rb
validates :my_attribute, behavior: { active?: true }
```

## Validation outside a model

If you need to validate a outside a model, you can do that:

```rb
BehaviorValidator.valid?(object, { method_name: expected_result }
```
