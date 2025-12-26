# Introduction
[Dragonfly](http://markevans.github.io/dragonfly/) is great for on the fly image processing in your Ruby or Rails
application.
Being an awesomely extensible software, dragonfly has a very clean and simple API for implemeting
[custom data stores](http://markevans.github.io/dragonfly/data-stores#building-a-custom-data-store).
There are data stores for Dragonfly that write to S3, MongoDB and CouchDB. There is an old project that provides
a [cloudinary based datastore](https://github.com/adie/dragonfly-cloudinary) for dragonfly. But that project is
not actively maintained and it doesn't work with the latest dragonfly interface for read, write and destory.

So I created this gem which supports the latest dragonfly interface.

# Usage

If using Cloudinary on Heroku, the config is read automatically from CLOUDINARY\_URL environment variable. Else, just download your cloudinary.yml file
and place it in your config directory.

Then in your dragonfly initializer, declare cloudinary as the data store with the following line.

```ruby
app.datastore = Dragonfly::CloudinaryDatastore.new
```

## With PushType CMS
[PushType](http://www.pushtype.org/) is a cool CMS for rails. If you want to use cloudinary for storing media in your PushType based application,
read ahead. You will specially need it if you want to run your PushType application on Heroku.

In the `config/initializers/push_type.rb` file, comment the line that configures `:file` datastore and add
the line `config.dragonfly_datastore = Dragonfly::CloudinaryDatastore.new`


# TODO

1. Add some tests

# Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request



