## ActiveSearch
#### By zachmokahn

This gem is simple, I'm hoping to add more to it as idea's come along. Please report any and all bugs, as well as any or all desired features. I'd love to make this better, or for you to make it better. Fork it, make pull requests, give me feedback. THANKS!

#### What does it do?

ActiveSearch adds some handy methods to ActiveRecord::Base Objects


```
#is_searchable?
#searchable?
```
```is_searchable?``` ( and it's alias ```searchable?``` ) detect whether or not a class that inherits from ActiveRecord::Base is searchable. By default when called on a class inheriting from ActiveRecord::Base it will return false.


```
#searchable_by(:parameters)
#findable_by(:parameters)
```
By adding ```searchable_by``` ( or it's alias ```findable_by``` ) to a class inheriting from ActiveRecord::Base it will become searchable by the provided parameters that correspond to those columns in the database.
When ```#searchable?``` is called on a class that includes ```searchable_by``` it will return true.


```
#find_by_value("value")
#search_for("value")
```
By calling ```find_by_value``` ( or it's alias ```search_for``` ) on a Class where ```is_searchable? == true``` it checks all the searchable parameters of that Class for a match. This method will make partial matches and is case insensitive.


```
#find_by_value("value", "association")
#search_for("value", "association")
```
When this method is called on an instance of a Class it require an association. It then check against a collection of the ActiveRecord::Associations for where the searchable parameters match.


#### How the Heck do you use this?
1. Install the Gem
    
    ```
    $ gem install active_search
    ```
or Require it in your Gemfile and bundle
    ```ruby
    gem 'active_search'
    ```
    ```
    $ bundle install
    ```
2. Make a class searchable

    ```ruby
    class Model < ActiveRecord::Base
      searchable_by :first_name, :last_name, :nickname
    end
    ```
3. Find instances of that class

    ```ruby
    Model.search_for("zachmo")
      => [#<Model id: 1, first_name: "Zack", last_name: "Mo", nickname: "zachmo", created_at: "2013-12-01 04:00:48", updated_at: "2013-12-01 04:00:48">]
    ```

===

##### Are you sure it works?
I test drove this whole development, so everything included works. (However there isn't much too it.... yet)
<img align="center" src="img/tests.png" />
Is it perfect? No. So you beta give me a break.
