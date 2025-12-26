# CabezaDeTermo::AssetsPublisher::Helper

A framework to declare bundles of assets in your Hanami application, compile them into a public folder and add them to your template.

## Status

[![Gem Version](https://badge.fury.io/rb/assets-publisher-for-hanami.svg)](https://badge.fury.io/rb/assets-publisher-for-hanami)
[![Build Status](https://travis-ci.org/cabeza-de-termo/assets-publisher-for-hanami.svg?branch=master)](https://travis-ci.org/cabeza-de-termo/assets-publisher-for-hanami)
[![Coverage Status](https://coveralls.io/repos/cabeza-de-termo/assets-publisher-for-hanami/badge.svg?branch=master&service=github)](https://coveralls.io/github/cabeza-de-termo/assets-publisher-for-hanami?branch=master)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'assets-publisher-for-hanami', '~> 2.0'
```

And then execute:

   $ bundle

Or install it yourself as:

   $ gem install assets-publisher-for-hanami

## Usage

To declare the asset bundles, add this required file to the application.rb file:

```ruby
require 'cabeza-de-termo/assets-publisher/helpers/helper'
```

and then add this to your Application class:

```ruby
module Web
   class Application < Hanami::Application
      configure do
         ...

         # Define the asset bundles.
         # See https://github.com/cabeza-de-termo/assets-library-for-hanami for more details.      
         CabezaDeTermo::Assets::Library.definition do
            # Css
            bundle :'bootstrap-css' do
               include '/vendor/bootstrap/css/bootstrap.min.css' # include this asset in the bundle
            end

            # Js
            bundle :jquery do
               include '/vendor/jquery/jquery-1.11.3.min.js'
            end

            bundle :'bootstrap-js' do
               require :jquery             # declare that this bundle depends on the :jquery bundle
               include '/vendor/bootstrap/js/bootstrap.min.js'
            end
         end

         # Configure the AssetsPublisher.
         CabezaDeTermo::AssetsPublisher::Publisher.configure do
            # Where we want to publish the compiled assets
            destination_folder 'apps/web/public'

            # Where to look for assets
            sources << 'apps/web/assets'

            # Optional, true by default.
            add_timestamps_to_published_assets true

            # Optionally uncomment to define custom compilers. You can also use :command_line_compiler
            # stylesheets_compiler { CustomCssCompiler.new }
            # javascripts_compiler { CustomJsCompiler.new }
         end

         ...
      end
   end
end
```

To define the assets to be included in the layout, you can add these methods to your Web::Views::ApplicationLayout class:

```ruby
module Web
   module Views
      class ApplicationLayout
         ...
         # Define the stylesheet for this layout
         def layout_stylesheets(assets_collector)
            assets_collector.require :'bootstrap-css'          # include the bundle :'bootstrap-css'
            assets_collector.include 'layout/layout.css.scss'  # include the asset layout.css.scss'
         end

         # Define the javascripts for this layout
         def layout_javascripts(assets_collector)
            assets_collector.require :'bootstrap-js'
         end
         ...
      end
   end
end
```

To define the assets to be included in the view, you can add these methods to your Web::Views::SomeView class:

```ruby
module Web::Views::LandingPage
   class Index
      include Web::View

      # Define the stylesheet for this view
      def view_stylesheets(assets_collector)
         assets_collector.include 'landing-page/landing-page.css.scss'
      end

      # Define the javascripts for this view
      def view_javascripts(assets_collector)
         assets_collector.include 'landing-page/landing-page.js'
      end
   end
end
```

To collect the assets, add the AssetsPublisher::Helper to your ApplicationLayout:

```ruby
module Web
   module Views
      class ApplicationLayout
         include Web::Layout
         include CabezaDeTermo::AssetsPublisher::Helper

            ...
      end
   end
end
```

and then use the assets_publisher from your layout template:

```ruby
doctype html
html
   head
      meta charset="UTF-8"
      meta name="viewport" content="width=device-width, initial-scale=1"

      / This will collect, publish and include all your stylesheets required by your layout and view
      == assets_publisher.stylesheets_for self

   body
      ...

      / This will collect, publish and include all your javascripts required by your layout and view
      == assets_publisher.javascripts_for self
```
## Using custom assets compilers

By default, Publisher uses a TiltCompiler to compile the assets. But you can change that to use a custom one.

If you compile the assets by invoking a command line, there is a `command_line_compiler` you can use. In this example we configure the Publisher to use [lesscss](http://lesscss.org/usage/#command-line-usage-command-line-usage) to compile stylesheets and [uglifyjs](https://github.com/mishoo/UglifyJS2) to compile the javascripts. For this to work you must first install those tools of course.

```ruby
CabezaDeTermo::AssetsPublisher::Publisher.configure do
   ...

	stylesheets_compiler {
		command_line_compiler do |compiler, compilation_job|
			files_list = compilation_job.source_filenames.join(' ')
			include_folders = compilation_job.source_folders.join(';')

			compiler.command_line "lessc",
				"--include-path=#{include_folders}", 
				"--compress",
				files_list, 
				compilation_job.destination_filename
		end
	}

   javascripts_compiler {
      command_line_compiler do |compiler, compilation_job|
         files_list = compilation_job.source_filenames.join(' ')
         compiler.command_line 'uglifyjs', files_list, '--output', compilation_job.destination_filename
      end
   }

   ...
end
```

If you need to write your own compiler, create a class that inherits from [CabezaDeTermo::AssetsPublisher::Compiler](lib/cabeza-de-termo/assets-publisher/compilers/compiler.rb)

```ruby
require 'cabeza-de-termo/assets-publisher/compilers/compiler'

class CustomCompiler < CabezaDeTermo::AssetsPublisher::Compiler
   def compile_assets()
      # you can access which files to compile with 
      compilation_job.source_filenames
      
      # you can access which file to compile to with 
      compilation_job.destination_filename
      
      # you can access the assets source folders with 
      compilation_job.source_folders

      # do compile the assets
      ...
   end
end
```

and then configure Publisher to use your custom compiler

```ruby
CabezaDeTermo::AssetsPublisher::Publisher.configure do
   ...
   stylesheets_compiler { CustomCompiler.new }

   # and/or

   javascripts_compiler { CustomCompiler.new }
   ...
end
```

## See also

* [**Hanami framework**](http://hanamirb.org/) - A complete web framework for Ruby.
* [**CabezaDeTermo::Assets::Library**](https://github.com/cabeza-de-termo/assets-library-for-hanami) - A framework to declare bundles of assets in your Hanami application and collect them resolving the dependencies.

## Running the tests

- `bundle install`
- `bundle exec rspec`

## Roadmap for v2.1

- Allow to define different compiling strategies:
   - One compiled file per asset (for development)
   - Maybe one compiled file per Action?
   - One compiled file per application (for production)

## Roadmap for v2.2

- Allow the assets_publisher to publish other asset types (images and fonts)

## Contributing

1. Fork it ( https://github.com/cabeza-de-termo/assets-publisher-for-hanami/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request