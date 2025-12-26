# activemodel-can_validator

[![Build Status](https://travis-ci.org/yuku-t/activemodel-can_validator.svg?branch=master)](https://travis-ci.org/yuku-t/activemodel-can_validator) [![Code Climate](https://codeclimate.com/github/yuku-t/activemodel-can_validator/badges/gpa.svg)](https://codeclimate.com/github/yuku-t/activemodel-can_validator) [![Coverage Status](https://coveralls.io/repos/yuku-t/activemodel-can_validator/badge.svg)](https://coveralls.io/r/yuku-t/activemodel-can_validator) [![Dependency Status](https://gemnasium.com/yuku-t/activemodel-can_validator.svg)](https://gemnasium.com/yuku-t/activemodel-can_validator)

Validate user permissions with [CanCan](https://github.com/CanCanCommunity/cancancan) API.

## Usage

Add to your Gemfile:

```rb
gem 'activemodel-can_validator'
```

Run:

```
bundle install
```

Then add the followng to your model which belongs to a user:

```rb
validates :user, can: { create: true }, on: :create
```

### Sample

A user can retweet other users' tweets unless she is blocked by the user.

```rb
class User < ActiveRecord::Base
  has_many :retweets

  def block?(user)
    blocking_users.include?(user)
  end

  delegate :can?, :cannot?, to: :ability

  def ability
    @ability ||= Ability.new(self)
  end

  class Ability
    include CanCan::Ability
    
    def initialize(user)
      user ||= User.new
  
      can :create, Retweet do |retweet|
        !retweet.tweet.user.block?(user)
      end
    end
  end
end

class Tweet < ActiveRecord::Base
  belongs_to :user
end

class Retweet < ActiveRecord::Base
  belongs_to :user
  belongs_to :tweet
  validates :user, presence: true, can: { create: true }, on: :create
end
```
