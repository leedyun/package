# Adapter::Sqlite3

Sqlite support for [https://github.com/jnunemaker/adapter](https://github.com/jnunemaker/adapter)

Adapted from the sqlite support in [https://github.com/minad/moneta](https://github.com/minad/moneta).

## Installation

Add this line to your application's Gemfile:

    gem 'adapter-sqlite3'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install adapter-sqlite3

## Usage

Usage is pretty simple:
```
require 'adapter/sqlite3'

client = ::SQLite3::Database.new('db/kv.sqlite3')

adapter = Adapter[:sqlite3].new(client)
adapter.write('foo', 'bar')
p adapter.read('foo')
```

Or under the hood in [https://github.com/jnunemaker/toystore](https://github.com/jnunemaker/toystore):
```
require 'pp'
require 'adapter/sqlite3'
require 'toystore'

class User
  include Toy::Store
  adapter :sqlite3, ::SQLite3::Database.new('db/kv.sqlite3')

  attribute :name, String
end

ids = []

user = User.create(:name => 'John')

pp user
pp User.read(user.id)

user.destroy
pp User.read(user.id)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
