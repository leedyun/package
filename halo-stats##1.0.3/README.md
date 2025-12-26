# HaloStats
[![Gem Version](https://badge.fury.io/rb/halo_stats.svg)](http://badge.fury.io/rb/halo_stats)
[![Code Climate](https://codeclimate.com/github/kylegrantlucas/halo_stats/badges/gpa.svg)](https://codeclimate.com/github/kylegrantlucas/halo_stats) 
[![Test Coverage](https://codeclimate.com/github/kylegrantlucas/halo_stats/badges/coverage.svg)](https://codeclimate.com/github/kylegrantlucas/halo_stats/coverage) 
[![Circle CI](https://circleci.com/gh/kylegrantlucas/halo_stats/tree/master.svg?style=shield)](https://circleci.com/gh/kylegrantlucas/halo_stats/tree/master) 
[![Inline docs](http://inch-ci.org/github/kylegrantlucas/halo_stats.svg?branch=master&style=shields)](http://inch-ci.org/github/kylegrantlucas/halo_stats) 
[![Join the chat at https://gitter.im/kylegrantlucas/halo_stats](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/kylegrantlucas/halo_stats?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Analytics](https://ga-beacon.appspot.com/UA-62799576-1/kylegrantlucas/halo_stats?pixel)](https://github.com/igrigorik/ga-beacon)

A ruby gem wrapper for the Halo 5 API.

## Requirements

All versions of MRI 1.9.3+ and up are supported (and tested via CircleCI), the gem is currently unsupported on JRuby, MRI 1.8-1.9.2, and Rubinus.
Support of these platforms is a future goal for the project.

## Installation

Add this line to your application's Gemfile:

    gem 'halo_stats'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install halo_stats

## Usage

### Quick Use

The first step is to instantiate some clients for the data we would like to grab:

    stats_client = Halo::StatsClient.new(api_key: 'APIKEY')
    profile_client = Halo::StatsClient.new(api_key: 'APIKEY')
    metadata_client = Halo::StatsClient.new(api_key: 'APIKEY')
    
From here you can begin calling your any api methods! 
So an example of call flow would be:

    matches_response = stats_client.get_matches('GAMERTAG')
    arena_match_response = stats_client.get_arena_carnage_report(match_response.first["Id"]["MatchId"])
    game_variant_response = metadata_client.get_game_variants(match_response["GameVariantId"])
    spartan_image_url = profile_client.get_spartan_image('GAMERTAG')
    
Results are returned as parsed ruby objects (generally a hash or an array of hashes).
      
## Contributing

1. Fork it ( https://github.com/kylegrantlucas/halo_stats/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
