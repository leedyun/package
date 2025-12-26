# ApplicationModule

This gem is meant to help with breaking down large Rails apps into modules.

[![Build Status](https://travis-ci.org/bagilevi/application_module.png)](https://travis-ci.org/bagilevi/application_module) [![Code Climate](https://codeclimate.com/github/bagilevi/application_module.png)](https://codeclimate.com/github/bagilevi/application_module)

## Installation

Add this line to your application's Gemfile:

    gem 'application_module'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install application_module

## Usage

Create a directory for your modules. A `modules` directory in the app
root works well for me.

In `config/application.rb`:

    config.autoload_paths += %W(#{config.root}/modules)

For each module, create a subdirectory and a ruby file:

    modules/animals.rb
    modules/animals/

`animals.rb`

    module Animals
      extend ApplicationModule
    end

Now you can create files like `modules/animals/tiger.rb` and
`Animals::Tiger` will be autoloaded from here.

You can create the usual `controllers/`, `models/`, `views/`
directories under `modules/animals/`, the classes in these need to be
namespaced under `Animals::`, but not
`Animals::Controllers::`.

By default if you want a subdirectory `services/`, then it will be
assumed that classes under it will be namespaced as
`Animals::Services::`. If you want it to behave like the
`controllers/` and other directories, you can do this:

    module Animals
      extend ApplicationModule
      autoload_without_namespacing 'services'
    end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
