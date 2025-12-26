# acmesmith-verisign

A plugin for [Acmesmith](https://github.com/sorah/acmesmith) and implements an automated `dns-01` challenge responder using Verisign MDNS REST API.

With this plugin and Acmesmith, you can automate and authorize your domain hosted on [Verisign MDNS Portal](https://mdns.verisign.com/mdns-web/login.xhtml) and request TLS certificates for the domains against [Let's Encrypt](https://letsencrypt.org/) and other CAs supporting the ACME protocol.

Please consider that Verisign API is closed by default and should be whitelist per IP address by opening a support case at mdnshelp@verisign.com.

For more infromation on Verisign API - [API Documentation](https://mdns.verisign.com/rest/rest-doc/index.html)

## Usage
### Prerequisites
- You need to whitelist your IP to access [Verisign API](https://mdns.verisign.com/mdns-web/api/v1/accounts/).
- You need to issue an API token from your [Verisign MDNS Portal](https://mdns.verisign.com/mdns-web/login.xhtml) UI.
- The user which generate the API token should have the *REGULAR* user role at minimum and should also be associated to all the DNS zones that will be managed by ACME.

### Installation
Install `acmesith-verisign` gem along with `acmesmith`. You can just do `gem install acmesith-verisign` or use Bundler if you want.

### Configuration
Use `verisign` challenge responder in your `acmesmith.yml`. General instructions about `acmesmith.yml` is available in the manual of [Acmesmith](https://github.com/sorah/acmesmith).

The mandatory options for the `acmesmith.yml` (Or other file specified from command line) are:
 - token: `VR API Token`
 - account_id: `VR Account ID`

 Optional option is:
  - ttl: `Integer` -> Where default TTL is 3600 if this option is omitted.

```yaml
---
directory: https://acme-v02.api.letsencrypt.org/directory

storage:
  type: filesystem
  path: /path/to/key/storage


challenge_responders:
  - verisign:
      token: "API_TOKEN" # (required)
      account_id: "ACCOUNT_ID" # (required)
      ttl: 60 # (optional)
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
