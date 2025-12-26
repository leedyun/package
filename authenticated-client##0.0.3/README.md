# SoarAuditingProvider

[![Gem Version](https://badge.fury.io/rb/authenticated_client.png)](https://badge.fury.io/rb/authenticated_client)

This gem provides authentication token generation and validation capability for the SOAR architecture.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'authenticated_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install authenticated_client

## Configuration

There are three modes of operation.
### Local
In local mode the tokens are decoded, verified and meta extracted locally using configured key material.

### Remote
In remote mode the tokens are passed to a validation service for dynamic validation.  The key material are therefore managed on the validation service.  In this mode you only have to provide the url of the validation service.

### Static
In this mode the validator are configured with a list of preconfigured static tokens.  Incoming tokens are simply checked against this list.  No extraction of meta is performed on the tokens but retrieved from the configuration.  This mode is to be used in only two scenarios:
* Between the various authentication token services that requires authentication between themselves.  These services do not have such a service to rely on. Circular dependency.
* In test scenarios where you do not want to pull in the authentication services to perform testing of your services.


## Testing

Run the rspec test tests using docker compose:

    $ docker-compose build
    $ docker-compose run --rm soar-authentication-token

Properly clean up containers afterwards:

    $ docker-compose down

Locally run a subset:

    $ bundle exec rspec -cfd spec/rack_middleware_spec.rb


## Updating

In order to pull the latest from the referenced projects, simply the following command:

```bash
git pull && git submodule foreach 'git fetch origin --tags; git checkout master; git pull'
docker-compose build
```

## Usage



## Detailed example



## Contributing

Bug reports and feature requests are welcome by email to barney dot de dot villiers at hetzner dot co dot za. This gem is sponsored by Hetzner (Pty) Ltd (http://hetzner.co.za)

## Notes



## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
