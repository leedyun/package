# Assembly


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'assembly-client', '~> 0.8.0'

```

## Usage

Some examples of how to pull information from the Assembly Platform API using the client Gem.

```ruby
require 'assembly-client'

Assembly.configure do |config|
  config.host  = 'https://api-sandbox.assembly.education/'       # For sandbox testing. Use https://api.assembly.education/ for production
  config.token = 'my_oauth_access_token'

  # You do not need this configuration for a quick play with the API. It's only needed for the refresh token OAuth flow.
  config.auth_host     = 'https://platform-sandbox.assembly.education/'  # For sandbox testing. Use https://platform.assembly.education/ for production
  config.refresh_token = 'my_oauth_refresh_token'
  config.client_id     = 'my_app_id'
  config.client_secret = 'my_app_secret'
end

api = Assembly.client

# Fetch all teaching groups (you may know these as classes) for the mathematics subject code.
maths_groups = api.teaching_groups.all(subject_code: 'MA')

maths_groups.each do |g|
  puts "Group Name: #{g.name}"
end

# Fetch all the students for this teaching group.
students = maths_groups.first.students(per_page: 100)

students.each do |student|
  puts "#{student.last_name}, #{student.first_name} (#{student.year_code})"
end

# ...or fetch all students filtered by year code/year group
api.students.all(year_code: '7')

```

## Development

Run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
