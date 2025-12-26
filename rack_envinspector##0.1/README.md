# Rack::EnvInspector, a Rack middleware for inspecting the Rack environment

This is a simple middleware that allows you to inspect the Rack environment by
appending a query parameter to any of your app's URLs.

## Configuration

To use Rack::EnvInspector, add the following to your Gemfile:

	gem 'rack-envinspector', :github => 'dancavallaro/rack-envinspector'

Then in `config.ru`:

	use Rack::EnvInspector

Or in a Rails app, add the following to `application.rb`, or to an appropriate
environment-specific config file:

	config.middleware.use "Rack::EnvInspector"

Then, see a JSON dump of the Rack environment by appending `?inspect` to any URL.
