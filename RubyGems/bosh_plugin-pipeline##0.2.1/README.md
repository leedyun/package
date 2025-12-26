# Bosh plugin pipeline
[![Build Status](https://travis-ci.org/Altoros/bosh-plugin-pipeline.svg?branch=master)](https://travis-ci.org/Altoros/bosh-plugin-pipeline)

This gem allows to create a file system tree structure for BOSH plugin and to update BOSH version in this plugin automatically. The project is build using [bosh-plugin-generator](https://github.com/Altoros/bosh-plugin-generator), that is no deprecated.

## What is BOSH?

BOSH orchestrates initial deployments and ongoing updates that are: predictable, repeatable, reliable, self-healing, infrastructure-agnostic. You can take a look on [BOSH project on GitHub](https://github.com/cloudfoundry/bosh) and read more details in [docs](http://docs.cloudfoundry.org/bosh/).

## How to install

```
gem install bosh-plugin-pipeline
```

## How to use

### Generating a BOSH CLI plugin

```
bosh generate plugin <plugin-name>
```

Possible attributes:

 * `--author` - a name of the plugin author, if is not specified it will be taken from `git` global config;
 * `--email` - email of the plugin author, if is not specified it will be taken from `git` global config;
 * `--description` - short description for your plugin;
 * `--license` - license type to generate license file;
 * `--no-travis` - do not expect to use travis with this plugin;

To get familiar with how to build your custom BOSH CLI plugin you'll find useful [this blog post](http://blog.altoros.com/cloud-foundry-internals-how-to-create-custom-bosh-cli-plugins.html).

To publish your plugin as a gem on [rubygems.org](http://rubygems.org/) see [this notes](http://guides.rubygems.org/publishing/).

### Updating BOSH version in your plugin

This command helps you to have support for uptodate BOSH version. You also may consider to use [gemnasium](https://gemnasium.com/) to keep track of other dependencies.

```
bosh update-bosh-version [path]
```

It takes as a parameter `path` to plugin, if `path` is not specified it uses current folder.

Possible attributes:

 * `--without-tests` - Don't run tests before commit
 * `--without-commit` - Don't do commit after update
 * `--without-push` - Don't push updated gem to github and rubygems

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## List of Contributors

* [Altoros](https://www.altoros.com)
