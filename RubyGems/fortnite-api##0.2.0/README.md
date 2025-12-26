# FortniteApi [![Build Status](https://travis-ci.org/romainr88/fortnite_api.svg?branch=master)](https://travis-ci.org/romainr88/fortnite_api)

fortnite_api allow you to retrieve informations from Fortnite in an easy way through fortnitetracker.com API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fortnite_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fortnite_api

## Usage

Initialize the API with your fortnitetracker.com API key's:
```ruby
fortnite = FortniteApi::Api.new('Enter your API Key here')
```

Enter the player's profile and the platform which you want to retrieve the informations (for the platform you have the choice between 'pc' for PC, 'xbl' for Xbox and 'psn' for Playstation):
```ruby
player = fortnite.get_json('pc','Ninja')
```

Now you have a player object with the following informations:

**Return the username:**
```ruby
player.epicuserhandle # return the username as a string
=> "Ninja"
```

**Return the platform:**
```ruby
player.platformnamelong # return the platform as a string
=> "PC"
```

**Return global and current season stats (solo, duo and squad stats):**

For returning stats you have the choice between ('globalsolo', 'globalduo', 'globalsquad', 'currentsolo', 'currentduo' and 'currentsquad') and after you can get the following informations ('trnrating', 'score', 'scorepermatch', 'top1', 'top10', 'top25', 'winratio', 'kills', 'kd' and 'kpg').
```ruby
player.globalsolo.top1 # return top 1 global solo information as a hash
 => {"label"=>"Wins", "field"=>"Top1", "category"=>"Tops", "valueInt"=>1843, "value"=>"1843", "percentile"=>0.1, "displayValue"=>"1,843"}
```
```ruby
player.globalduo.score # return score global duo stats as a hash
 => {"label"=>"Score", "field"=>"Score", "category"=>"General", "valueInt"=>1780621, "value"=>"1780621", "percentile"=>0.1, "displayValue"=>"1,780,621"} 
```
```ruby
player.globalsquad.kills # return kills global squad stats as a hash
 => {"label"=>"Kills", "field"=>"Kills", "category"=>"General", "valueInt"=>27656, "value"=>"27656", "percentile"=>0.1, "displayValue"=>"27,656"} 
```
```ruby
player.currentsolo.winratio # return winratio current solo stats as a hash
 => {"label"=>"Win %", "field"=>"WinRatio", "category"=>"General", "valueDec"=>25.0, "value"=>"25", "percentile"=>0.7, "displayValue"=>"25.00"} 
```
```ruby
player.currentduo.kpg # return kills per match current duo stats as a hash
 => {"label"=>"Kills Per Match", "field"=>"KPG", "category"=>"General", "valueDec"=>5.76, "value"=>"5.76", "percentile"=>0.1, "displayValue"=>"5.76"} 
```
```ruby
player.currentsquad.trnrating # return TRN Rating current squad stats as a hash
 => {"label"=>"TRN Rating", "field"=>"TRNRating", "category"=>"Rating", "valueInt"=>4868, "value"=>"4868", "percentile"=>0.1, "displayValue"=>"4,868"} 
```
You can also custom the informations you want to get (you can retrieve all the informations of the stats, e.g., 'player.globalsolo.custom'):
```ruby
player.globalsolo.custom['top5'] # return top 5 global solo information as a hash
  => {"label"=>"Top 5", "field"=>"Top5", "category"=>"Tops", "valueInt"=>0, "value"=>"0", "displayValue"=>"0"} 
```

**Return lifetime stats:**
```ruby
player.lifetimestats # return lifetime stats as an array
=> [{"key"=>"Top 3", "value"=>"1518"}, {"key"=>"Top 5s", "value"=>"1318"}, {"key"=>"Top 3s", "value"=>"387"}, {"key"=>"Top 6s", "value"=>"477"},..., "value"=>"54518"}, {"key"=>"K/d", "value"=>"11.05"}]
```

**Return recent matches:**
```ruby
player.recentmatches # return recent matches as an array
=> [{"id"=>210645397, "accountId"=>"4735ce91-3292-4caf-8a5b-17789b40f79c", "playlist"=>"p10", "kills"=>10, "minutesPlayed"=>0, "top1"=>1, "top5"=>1,...,  "trnRating"=>4472.8, "trnRatingChange"=>-12.857500000000005}]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/romainr88/fortnite_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the FortniteApi project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/romainr88/fortnite_api/blob/master/CODE_OF_CONDUCT.md).
