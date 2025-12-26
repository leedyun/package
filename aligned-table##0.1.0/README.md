# AlignedTable

An easy way to create simple lightweight text tables with a
right-aligned first column, total row, and title.

## Installation

Add this line to your application's Gemfile:

    gem 'aligned_table'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aligned_table

## Usage

### Basic Usage
```ruby
at = AlignedTable.new
at.title = "My Title"
at.separator = " | "
at.rows = [
  ["My Cool Column", "Some data"],
  ["More data", "Info"]
]

puts at.render
```

gives you

```
======= My Title =======
My Cool Column Some data
     More data Info
```

### Custom Separators
```ruby
at = AlignedTable.new
at.title = "My Title"

at.rows = [
  ["My Cool Column", "Some data"],
  ["More data", "Info"]
]

puts at.render
```

gives you

```
======== My Title ========
My Cool Column | Some data
     More data | Info
```


### Column Lines
Pass a symbol instead of a string, and the output will be repeated
for the length of the line
```ruby
at = AlignedTable.new
at.title = "My Title"

at.rows = [
  ["My Cool Column", "Some data"],
  ["More data", "Info"],
  [nil, :-],
  [nil, "Total: 15 bananas"]
]

puts at.render
```

gives you

```
=========== My Title ===========
My Cool Column Some data
     More data Info
               -----------------
               Total: 15 bananas
```


## Contributing

1. Fork it ( http://github.com/ubercow/aligned_table/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
