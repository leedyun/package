Feature: The public interface documented in the README

  @disable-bundler
  Scenario: First installation using Bundler
    Given a file named "Gemfile" with:
    """
    gem "batch_it", path: "../../"
    """
    And a file named "example.rb" with:
    """
    require 'batch_it'
    require 'ostruct'

    puts BatchIt.new(DATA.read).result([OpenStruct.new(title: "One"), OpenStruct.new(title: "Two")])
    __END__
    <%= title %>
    =
    """
    And I run `bundle install > /dev/null`
    When I successfully run `bundle exec ruby example.rb` for up to 6 seconds
    Then the output should contain:
    """
    <h1>One</h1>
    <h1>Two</h1>
    """
