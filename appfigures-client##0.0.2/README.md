#AppFigures API Client

A Ruby wrapper for appfigures.com API
##Installation

In your Gemfile you need to add the `appfigures_client` gem:
```ruby
gem 'appfigures_client'
```
And then run the bundler and restart your server to make the files available through the pipeline:
```console
$ bundle install
```
Or install it separately:

```console
$ gem install appfigures_client
```
##Usage
For more information read http://docs.appfigures.com/

```ruby
require 'appfigures_client'
api = AppfiguresClient.init(USERNAME, PASSWORD, CLIENT_KEY)
api.products.search(options={}) # return products list
api.products.get(id) # return product by id
api.products.all(store = nil) # returns products list from store
api.sales.search(options = {}) # return sales report
api.sales.search_by_regions(options = {}) # return sales report by regions
api.ads.search(options = {}) # returns ads report
api.reviews.search(options = {}) # returns reviews 
api.reviews.counts(options = {}) # returns review counts
api.ranks.search(options = {}) # returns ranks report
api.ranks.snapshot(options = {}) # returns ranks report

```


## Contributing
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2015 Aleksey Dmitriev. See LICENSE.txt for
further details.

