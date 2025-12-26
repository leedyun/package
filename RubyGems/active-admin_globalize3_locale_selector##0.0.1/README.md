# Active Admin Globalize3 Locale Selector

This gem adds controls to change the locale used by Globalize3 in Active Admin views. It allows you to see the content in the specified locale while keeping the admin interface in your preferred locale.

## Installation

Add this line to your application's Gemfile:

    gem 'active_admin_globalize3_locale_selector'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_admin_globalize3_locale_selector

## Usage

In the first place you have to include the css from this gem:

Rails assets pipeline:

    //= require globalize3_locale_selector

SASS:

    @import "globalize3_locale_selector";

Create your Active Admin resources as usual and use this gems' DSL to add the locale selector.

The locale select can be shown in a sidebar (by default) or as an action item. All options but "as" are passed to the corresponding ActiveAdmin's view.

Examples:

    change_globalize3_locale
    # Shows in all views in a sidebar panel

    change_globalize3_locale :only => [:index, :show]
    # Just in index and show views

    change_globalize3_locale :only => [:index, :show], :as => :action_item
    # Show the locale select as an action item (instead of as a sidebar)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
