# BattleOn

A little weapon to help fight Platform45's Battleship API

## Installation

Add this line to your application's Gemfile:

    gem 'battle-on'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install battle-on

Now you're ready to attack!

## Usage

When you're in the middle of game of Battleship you want to focus on
your attack - we help you do that. 

First, require 'battle_on'

    require 'battle_on'

Now you're ready to begin the game. To start a new game, all that's
required is your name and email:

    BattleOn.begin("Johnny Johnson", "Johnny@example.com")

This will return a hash with your game id and Platform45's first attack:

    {:id => 101, :x => 3, :y => 8}

Once you've started a game, you can launch your attacks. It expects your
game id and the attack coordinates as two arguments passed to the attack
method:

    BattleOn.attack(101, {:x => 1, :y => 7})

This will return a hash with the status of your last attack, whether it
was a hit or miss, and Platform45's next attack. Expect it to look like
this:

    {:status => "hit", :x => 5, :y => 5}


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
