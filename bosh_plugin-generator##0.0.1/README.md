# Bosh plugin generator
[![Build Status](https://travis-ci.org/Altoros/bosh-plugin-generator.svg?branch=master)](https://travis-ci.org/Altoros/bosh-plugin-generator)

This gem creates file system tree structure for BOSH plugin. BOSH installs and updates software packages on large numbers of VMs over many IaaS providers with the absolute minimum of configuration changes.

## What is BOSH?
BOSH orchestrates initial deployments and ongoing updates that are: predictable, repeatable, reliable, self-healing, infrastructure-agnostic. You can take a look on [BOSH project on GitHub](https://github.com/cloudfoundry/bosh) and read more details in [docs](http://docs.cloudfoundry.org/bosh/).

## How to install
```
gem install bosh-plugin-generator
```

## How to use
```
bosh generate plugin <plugin-name>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## List of Contributors

* [Altoros](https://www.altoros.com)
