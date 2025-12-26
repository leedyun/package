# abbish_sequel_plugins

Frequently used plugins for Sequel

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'abbish_sequel_plugins'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install abbish_sequel_plugins

## Plugin super_record
###protection
Protecting record cannot destroy and raise error when destroy it
```ruby
class Model < Sequel::Model(:test_table)
  plugin Abbish::Sequel::Plugins::Model::SuperRecord::Protection { options }
end
```
Default options
```ruby
{
    :enabled => true,
    :feature_column_protected => :record_protected,
    :raise_protected_message => 'Cannot destroy protected record'
}
```
use ```set_record_protected!``` to set record being protected  
```ruby
model = Model.create(:table_field => 'test')
model.set_record_protected!
```
use ```set_record_protected``` and ```save``` to set record being protected  
```ruby
model2 = Model.create(:table_field => 'test2')
model2.set_record_protected
model2.save
```
destroy protected record will raise a ProtectedError  
use ```delete``` will skip record protection feature and record will be deleted
```ruby
model.destroy 
```
======
###timestamp
Automatically add current date time to record when record was created and updated
```ruby
class Model < Sequel::Model(:test_table)
  plugin Abbish::Sequel::Plugins::Model::SuperRecord::Timestamp { options }
end
```
Default options
```ruby
{
    :enabled => true,
    :feature_column_created_time => :record_created_time,
    :feature_column_updated_time => :record_updated_time
}
```
======
###version
Automatically generate hash string be record version when record was created and updated
```ruby
class Model < Sequel::Model(:test_table)
  plugin Abbish::Sequel::Plugins::Model::SuperRecord::Version
end
```
Default options
```ruby
{
    :enabled => true,
    :feature_column_version => :record_version
}
```
======
## Contributing

1. Fork it ( https://github.com/abbish/abbish_sequel_plugins/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
