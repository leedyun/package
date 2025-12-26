# ActiveMerchant Payline

[![Build Status](https://travis-ci.com/c4ddna/active_merchant_payline.svg?token=TCtHVJZbagUskWponM9C&branch=master)](https://travis-ci.com/c4ddna/active_merchant_payline)

ActiveMerchant implementation of the [Payline] [1] Gateway.

## Installation

Add this line to your application's Gemfile:

  gem 'activemerchant-payline'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activemerchant-payline


## Usage

```
  payline = PaylineGateway.new(
    merchant_id: "1234567891011" # Your merchant ID,
    merchant_access_key: "your_merchant_api_access_key",
    contract_number: "1234567",
    return_url: "http://test.com",
    cancel_return_url: "http://test.com",
    test: true
  )

  payline.do_web_payment(100, order_id: "MYORDERID")
```

Please note that all methods aren't implemented yet. Contributions are welcome.

## Useful payline links
Test API: http://www.concupourvendre.com/demo/
Documentation: https://payline.atlassian.net/wiki/display/DT/Documentation

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Test your code:
- Create a .env file in the test folder and complete it following the .env.example
- Write your tests and launch tests using the ruby test/run_test.rb command


[1]: http://www.payline.com/
[2]: https://homologation-admin.payline.com/
