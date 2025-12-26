# ActiveModelValidatorsEx

[![Gem Version](https://badge.fury.io/rb/active_model_validators_ex.svg)](http://badge.fury.io/rb/active_model_validators_ex)
[![build](https://travis-ci.org/junhanamaki/active_model_validators_ex.svg?branch=master)](https://travis-ci.org/junhanamaki/active_model_validators_ex)
[![Code Climate](https://codeclimate.com/github/junhanamaki/active_model_validators_ex/badges/gpa.svg)](https://codeclimate.com/github/junhanamaki/active_model_validators_ex)
[![Test Coverage](https://codeclimate.com/github/junhanamaki/active_model_validators_ex/badges/coverage.svg)](https://codeclimate.com/github/junhanamaki/active_model_validators_ex)
[![Dependency Status](https://gemnasium.com/junhanamaki/active_model_validators_ex.svg)](https://gemnasium.com/junhanamaki/active_model_validators_ex)

A library of validators for ActiveModel.

## Installation

Add this line to your application's Gemfile:

    gem 'active_model_validators_ex'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_model_validators_ex

## Localization

Translations are supported by [I18n](https://github.com/svenfuchs/i18n) and follows
the established convention. Default translations are available in the folder
[config/locales](https://github.com/junhanamaki/active_model_validators_ex/tree/master/config/locales)
of this project, so just copy them to your project and edit as needed.

## Usage

After requiring, the following classes will be available for ActiveModel
validations:

  * ArrayInclusionValidator

   Validates if attribute value is an Array, containing values defined under key
   :in (this can be defined either with an Array or Range). As an example:

        class ExampleModel
          include Mongoid::Document

          field :array

          validates :array, array_inclusion: {
              # the collection of values to compare with each element in array
              in: [0, 1, 2], # this could also be written as a range: 0..2

              # can be either true or false, indicates if nil is accepted
              # defaults to false
              allow_nil: true,

              # can be either true or false, indicates if it accepts blank value
              # defaults to false
              allow_blank: true
            }
        end

        # returns true
        ExampleModel.new(array: [1, 2, 1]).valid?

        # returns false
        ExampleModel.new(array: [1, 2, 5]).valid?

        # returns true
        ExampleModel.new(array: []).valid?

   Used translation keys: array, blank, array_inclusion

  * ArrayFormatValidator

        class ExampleModel
          include Mongoid::Document

          field :array

          validates :array, array_format: {
            # the regexp to compare each element in array
            with: /(some|match|string)/

            # can be either true or false, indicates if nil is accepted
            # defaults to false
            allow_nil: true,

            # can be either true or false, indicates if it accepts blank value
            # defaults to false
            allow_blank: true
          }
        end

        # returns true
        ExampleModel.new(array: ['some', 'match', 'string']).valid?

        # return false
        ExampleModel.new(array: ['not', 'matching']).valid?

   Used translation keys: array, blank, array_format

  * TimeFormatValidator

   Validates if value is of type Time or a string parsable to Time, example:

        class ExampleModel < ActiveRecord::Base
          attr_accessible :time

          validates :time, time_format: {
              # value can be either a lambda or a time, and indicates that
              # attribute value must be after this value
              after: lambda { |model| Time.new(2014) },

              # can be either true or false, indicates if nil is accepted
              # defaults to false
              allow_nil: true
            }
        end

        # returns true
        ExampleModel.new(time: Time.new(2015)).valid?

        # returns false
        ExampleModel.new(time: Time.new(2013)).valid?

   Used translation keys: time_greater_than, time_invalid

## Contributing

1. Fork it ( https://github.com/junhanamaki/active_model_validators_ex/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
