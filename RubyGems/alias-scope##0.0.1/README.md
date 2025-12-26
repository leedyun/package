# AliasScope

alias_scope is like alias_method for Active Record scopes


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'alias_scope'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alias_scope

## Usage

```ruby
class Address < ActiveRecord::Base
  scope :by_zip_code, -> zip_code { where("zip_code = ?", zip_code) }
  alias_scope :by_postal_code, :by_zip_code
end

Address.by_zip_code('90210')
Address.by_postal_code('90210')
```

You can also create multiple aliases by providing an array:

```ruby
class Fabric < ActiveRecord::Base
  scope :flammable, -> { where(flammable: true) }
  alias_scope [:inflammable, :can_catch_on_fire], :flammable
end
```
