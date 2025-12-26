at\_least\_one\_existence\_validator [![Build Status](https://travis-ci.org/USAWal/at_least_one_existence_validator.png)](https://travis-ci.org/USAWal/at_least_one_existence_validator)
====================================

Easy to use Rails active model validator which tests whether an associated collection will have any objects after saving. It's useful with one-to-many and many-to-many relationships.

Installation
------------

Add to the `Gemfile`:
```ruby
gem 'at_least_one_validator'
```
After adding, install it
```shell
bundle install
```

Usage
-----

Given you have 'Author' model and 'Book' model respectively. Obviously author can write many books and book can be written by many authors but a book must have at least one author, so eventually you have something like this:

```ruby
class Author < ActiveRecord::Base
  has_and_belongs_to_many :books
end

class Book   < ActiveRecord::Base
  has_and_belongs_to_many :authors
end
```

If you want to use **at_least_one_existence_validator**, you just need to add helper method ```validates_at_least_one_existence_of```to the model class and list all the collections you want to be validated as parameters. Let's do it:

```ruby
class Author < ActiveRecord::Base
  has_and_belongs_to_many :books
end

class Book   < ActiveRecord::Base
  has_and_belongs_to_many :authors

  validates_at_least_one_existence_of :authors
end
```

This code will test whether the authors of the tested book are marked for destruction or authors are already blank. If they are, validator will add default error message.

Configuring
-----------

The default error message for English locale is "must have at least one item.". You can specify your own error message adding it with ```at_least_one:``` key to localization backend. Using previous example and standard i18n localization mechanism for static content we do the next:

```ruby
# file project_root/config/locales/en.yml
en:
  activerecord:
    errors:
      models:
        book:
          attributes:
            authors:
              at_least_one: 'must have at least one author.'
```

Message for **at_least_one_existence_validator** scoped by book and its authors is changed now.

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
