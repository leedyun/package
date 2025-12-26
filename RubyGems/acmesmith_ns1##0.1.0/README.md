# acmesmith-ns1

A plugin for [Acmesmith](https://github.com/sorah/acmesmith) and implements an automated `dns-01` challenge responder using NS1 API.

With this plugin and Acmesmith, you can automate and authorize your domain hosted on [NS1 Portal](https://my.nsone.net) and request TLS certificates for the domains against [Let's Encrypt](https://letsencrypt.org/) and other CAs supporting the ACME protocol.

For more infromation on NS1 API - [API Documentation](https://ns1.com/api)
NS1 calls are managed by `ns-1` gem see [ns-1](https://rubygems.org/gems/ns-1)

## Usage
### Prerequisites
- You need to issue an API token from your [NS1 Portal](https://my.nsone.net).
- And attached the relevant permissions to the API token

### Installation
Install `acmesith-ns1` gem along with `acmesmith`. You can just do `gem install acmesith-ns1` or use Bundler if you want.

### Configuration
Use `ns1` challenge responder in your `acmesmith.yml`. General instructions about `acmesmith.yml` is available in the manual of [Acmesmith](https://github.com/sorah/acmesmith).

The mandatory options for the `acmesmith.yml` (Or other file specified from command line) are:
 - token: `NS1 API Token`

 Optional option is:
  - ttl: `Integer` -> Where default TTL is 3600 if this option is omitted.

```yaml
---
directory: https://acme-v02.api.letsencrypt.org/directory

storage:
  type: filesystem
  path: /path/to/key/storage

challenge_responders:
  - ns1:
      token: "API_TOKEN" # (required)
      ttl: 60 # (optional)
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
