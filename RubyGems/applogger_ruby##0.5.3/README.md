applogger-ruby
==============

The official Ruby SDK for the applogger.io service (Releases are in the master branch)  Visit 
https://applogger.io to get more information.

# Getting Started

## Install the rubygem package

You can install the applogger rubygem package directly.

```bash
gem install applogger-ruby
```

## Use the applogger tool

The simples way to push logs to the platform is using our applogger client which is part of the install gem. Just
use the following command line:

```bash
tail -f /var/log/message | applogger --app <<YOUR APPID>> --secret <<YOUR APPSECRET>>
```