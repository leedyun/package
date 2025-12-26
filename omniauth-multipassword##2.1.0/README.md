# Omniauth::Multipassword

[![Gem Version](https://img.shields.io/gem/v/omniauth-multipassword?logo=ruby)](https://rubygems.org/gems/omniauth-multipassword)
[![Workflow Status](https://img.shields.io/github/actions/workflow/status/jgraichen/omniauth-multipassword/test.yml?logo=github)](https://github.com/jgraichen/omniauth-multipassword/actions)
[![Test Coverage](https://img.shields.io/codecov/c/github/jgraichen/omniauth-multipassword?logo=codecov&logoColor=white)](https://app.codecov.io/gh/jgraichen/omniauth-multipassword)
[![Code Climate](https://codeclimate.com/github/jgraichen/omniauth-multipassword/badges/gpa.svg)](https://codeclimate.com/github/jgraichen/omniauth-multipassword)

**omniauth-multipassword** is a [OmniAuth](https://github.com/intridea/omniauth)
strategy that allows to authenticate again different password strategies at once.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omniauth-multipassword'
```

Add multipassword compatible omniauth strategies you want to use:

```ruby
gem 'omniauth-internal'
gem 'omniauth-kerberos'
```

And then execute:

```console
bundle
```

Or install it yourself as:

```console
gem install omniauth-multipassword
```

## Usage

```ruby
Rails.application.config.middleware.use OmniAuth::Strategies::MultiPassword, fields: [ :auth_key ] do |mp|
  mp.authenticator :internal
  mp.authenticator :kerberos
end
```

## Options

<dl>
  <dt><code>title</code></dt>
  <dd>

The title text shown on default login form.
(default: `"Restricted Access"`)

  </dd>
  <dt><code>fields</code></dt>
  <dd>

The request parameter names to fetch username and password.
(default: `[ "username", "password" ]`)

  </dd>
</dl>

### Compatible Strategies

- [omniauth-internal](https://github.com/jgraichen/omniauth-internal)
- [omniauth-kerberos](https://github.com/jgraichen/omniauth-kerberos)

## License

[MIT License](http://www.opensource.org/licenses/mit-license.php)

Copyright © 2012, Jan Graichen
