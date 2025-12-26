# CrlWatchdog

Checks if an OpenSSl certificate revocation file expires within a given amount of days.

## Installation

Install the system executable:

    $ gem install crl_watchdog

## Usage

    $ crlwatch --file /path/to/crl.pem --days 14

The CLI returns 0 if the CRL expires after the given amount of days and 1 if
the expiration date is within the given period.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
