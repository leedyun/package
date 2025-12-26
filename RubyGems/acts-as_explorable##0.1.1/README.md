# Acts As Explorable

[![Gem Version](https://badge.fury.io/rb/acts_as_explorable.svg)](http://badge.fury.io/rb/acts_as_explorable) [![Build Status](https://travis-ci.org/hiasinho/acts_as_explorable.svg?branch=develop)](https://travis-ci.org/hiasinho/acts_as_explorable) [![Code Climate](https://codeclimate.com/github/hiasinho/acts_as_explorable/badges/gpa.svg)](https://codeclimate.com/github/hiasinho/acts_as_explorable) [![Inline docs](http://inch-ci.org/github/hiasinho/acts_as_explorable.svg?branch=develop)](http://inch-ci.org/github/hiasinho/acts_as_explorable)

Acts As Explorable extends ActiveRecord models with a `search` class method. This method can be fed with a quer like `Madrid in:city position:MF sort:club`. Which means *"Get all players who play in Madrid on the midfielder position and sort the results by the club names"*.

Acts As Explorable is a Ruby Gem specifically written for ActiveRecord models. It uses [Arel](https://github.com/rails/arel) to build query parts.

## Installation

### Supported Ruby and Rails versions

* Ruby 2.0.0, 2.1.0
* Rails 4.0, 4.1, 4.2+

### Install

Just add the following to your Gemfile.

```ruby
gem 'acts_as_explorable', '~> 0.1.1'
```

And follow that up with a ``bundle install``.

## Usage

To enable the explorable plugin, just include the following lines into your model:

```ruby
class Foo < ActiveRecord::Base
  extend ActsAsExplorable
  explorable
end
```

Now you have the `.search` method on your model, which can be invoked like 

```ruby
Foo.search('Awesome in:bar')
```

A query string consists of two different types: The values (random words) and filters (starting with a word followed by a `:` and again a word -> `in:bar`). As of writing this, there are three different kinds of filters.

### Filters

A filter always consists of an element (the string before the `:`) and the *"modifiers"*, which can be appended with a `,`. Optional you can add a `-` for options (only used in `sort:` at the moment).

#### In

The `in:` filter makes use of the values given in the query string. It looks up these values in the given columns. For example the following query will look up all posts with the word *"Zlatan"* in the title or the body:

`Zlatan in:title,body`

You can do that by defining the `in:` filter on your model:

```ruby
class Post < ActiveRecord::Base
  extend ActsAsExplorable
  explorable in: [:title, :body]
end
```

As you see, it is possible to look up the value in different columns. This generates some SQL like:

```sql
SELECT posts.* FROM posts 
  WHERE (posts.title ILIKE '%Zlatan%' OR posts.body ILIKE '%Zlatan%') 
```

#### Sort

The `sort:` filter does (guess what?!) sorting. Just write `sort:` followed by the columns you want to sort. You can also append a `-desc` or `-asc` for the direction. So the query `sort:created_at-asc` sorts all posts be the `created_at` column in ascending direction. 

Just define the `sort:` filter for your model:

```ruby
class Player < ActiveRecord::Base
  extend ActsAsExplorable
  explorable sort: [:title, :created_at]
end
```

You can add more sorts just by addding the with a comma. `sort:created_at-asc,title-desc`. This produces the following SQL:

```sql
SELECT posts.* FROM posts 
  ORDER BY posts.created_at ASC, posts.title DESC
```

#### Dynamic Filters

This is where the *"magic"* happens. Say you have a model that represents a football player. And this player plays on a specific position. If you want to find all midfielders you could do `MF in:position` or you could use a dynamic filter.

You can define these filters on your model and assign options to them like this:

```ruby
class Player < ActiveRecord::Base
  extend ActsAsExplorable
  explorable position: ['GK', 'DF', 'MF', 'FW']
end
```

Now, given a quer string `position:MF,FW` will give you all midfielders an forwards. Nice! This is the SQL:

```sql
SELECT players.* FROM players 
  WHERE (players.position IN ('MF','FW')) 
```

#### Wrap Up

So, using all these examples, assuming you have this model:

```ruby
class Post < ActiveRecord::Base
  extend ActsAsExplorable
  explorable in: [:title, :body],
             sort: [:title, :created_at],
             state: ['draft', 'published', 'trash']

  scope :older_than, -> (date) { where(%q{created_at <= ?}, date) }
end
```

You could query all posts in *draft* state with *"Zlatan"* in the title or body and sort the ascending by their creation date.

`Zlatan in:title,body sort:created_at-asc state:draft`

```ruby
Post.search('Zlatan in:title,body sort:created_at-asc state:draft')
```

Now we have a SQL like this:

```ruby
SELECT posts.* FROM posts 
  WHERE (posts.title ILIKE '%Zlatan%' OR posts.body ILIKE '%Zlatan%')
    AND (posts.state IN ('draft'))
  ORDER BY 
    posts.created_at ASC
```

You can also append your scopes:

```ruby
Post.search('Zlatan in:title,body sort:created_at-asc state:draft').older_than(DateTime.now)
```

## Testing

All tests follow the RSpec format and are located in the spec directory.
They can be run with:

```
rake spec
```

## License

Acts as explorable is released under the [MIT License](http://www.opensource.org/licenses/MIT).

## TODO

###v0.x
- Add tests for postgres and mysql
- Query string validation helper for use in forms
- Use methods in addition to fields
- Use named scopes
