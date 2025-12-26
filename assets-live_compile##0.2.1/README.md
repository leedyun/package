assets_live_compile
===================
Compile and save assets on demand instead of using `rake assets:precompile`

This works just like `rake assets:precompile` but is triggered on the asset HTTP request, so the cost of compilation is due to the first asset request.

`assets_live_compile` will save the file on `public/assets`, exactly how `rake assets:precompile` would do. Next time Nginx will find the static asset there and the Rails app won't be reached.

Compile your assets by doing a warm up request :)

Configuration
-------------
Add it to your Gemfile:
```ruby
group :assets do
  gem 'assets_live_compile'
  ...
end
```

On `config/application.rb`, load the `:assets` group of the `Gemfile`:
```ruby
Bundler.require :default, :assets, Rails.env
```

Then configure `config/environments/production.rb`,

On Rails 4:
```ruby
config.assets.serve_static_assets = true
config.assets.configure do |env|
  env.cache = Sprockets::Cache::AssetsLiveCompileStore.new
end
```

On Rails 3:
```ruby
config.assets.serve_static_assets = true
config.assets.cache_store = :assets_live_compile_store
```
