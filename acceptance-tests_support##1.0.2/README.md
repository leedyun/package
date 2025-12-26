# AcceptanceTestsSupport - This gem simplifies congiguration and run of acceptance tests

## Installation

Add this line to to your Gemfile:

    gem "acceptance_tests_support"

And then execute:

    $ bundle

## Usage

```ruby
require 'acceptance_tests_support'

shared_context "AcceptanceTest" do |support|

  before do
    support.before self
  end

  after do
    support.after self
  end

end

selenium_config_file = "#{File.expand_path(Rails.root)}/spec/features/support/selenium.yml"
selenium_config_name = 'test'

selenium_config = AcceptanceTestsSupport.load_selenium_config selenium_config_file, selenium_config_name

support = AcceptanceTestsSupport.new Rails.root, selenium_config

feature 'Google Search', %q{
    As a user of this service
    I want to enter a search text and get the relevant search results
    so that I can find the right answer
  } do

  include_context "AcceptanceTest", support

  before :all do
    @support.app_host = "http://www.google.com"
  end

  scenario "uses selenium driver", driver: :selenium, exclude: false do
    visit('/')

    fill_in "q", :with => "Capybara"

    #save_and_open_page

    find("#gbqfbw button").click

    all(:xpath, "//li[@class='g']/h3/a").each { |a| puts a[:href] }
  end

end

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request