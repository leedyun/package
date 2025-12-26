# GameShuffleCards

A Game to shuffle a deck of cards and presents the result
With the class Game you can handle a deck of cards and setting the players and the cards per player. And shuffle the deak of cards.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'game_shuffle_cards'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install game_shuffle_cards

## Usage
```ruby
# create a new game with 5 players and 3 cards per player
game = Game.new(5,3)
# to shuffle a deck of cards , 3 cards per player , to 5 players
game.results

 {0=>["8 of spades", "Q of clubs", "5 of diamonds", "3 of hearts"], 1=>["9 of spades", "5 of clubs", "9 of clubs", "J of clubs"]}
 ```


If you repeat the `game.result` the deck will go emptying

 ```bash
2.2.0 :003 > g.results
 => {0=>["8 of spades", "Q of clubs", "5 of diamonds", "3 of hearts"], 1=>["9 of spades", "5 of clubs", "9 of clubs", "J of clubs"]}
2.2.0 :004 > g.results
 => {0=>["10 of clubs", "A of clubs", "5 of hearts", "4 of spades"], 1=>["Q of diamonds", "2 of hearts", "3 of spades", "8 of clubs"]}
2.2.0 :005 > g.results
 => {0=>["6 of clubs", "A of diamonds", "10 of diamonds", "J of hearts"], 1=>["7 of spades", "8 of hearts", "K of diamonds", "4 of clubs"]}
2.2.0 :006 > g.results
 => {0=>["Q of hearts", "7 of diamonds", "9 of hearts", "10 of hearts"], 1=>["2 of clubs", "4 of hearts", "4 of diamonds", "7 of clubs"]}
2.2.0 :007 > g.results
 => {0=>["5 of spades", "J of spades", "9 of diamonds", "10 of spades"], 1=>["2 of diamonds", "A of hearts", "K of clubs", "3 of diamonds"]}
2.2.0 :008 > g.results
 => {0=>["2 of spades", "6 of diamonds", "6 of spades", "K of hearts"], 1=>["A of spades", "3 of clubs", "8 of diamonds", "K of spades"]}
2.2.0 :009 > g.results
 => {0=>["J of diamonds", "7 of hearts", "Q of spades", "6 of hearts"], 1=>[]}
2.2.0 :010 > g.results
 => {0=>[], 1=>[]}
 ```
If you want to repeat the operation with the same deck, you could instantiate an object again

 ```ruby
game = Game.new
 ```

And the deck will be full again.


The deck has defined in class Game the constants you can change it to another type of deck.
By default there are 52 cards: 4 suits and 13 values, they are
			|A of clubs			|
			|2 of clubs			|
			|3 of clubs			|
			|4 of clubs			|
			|5 of clubs			|
			|6 of clubs			|
			|7 of clubs			|
			|8 of clubs			|
			|9 of clubs			|
			|10 of clubs		|
			|J of clubs			|
			|K of clubs			|
			|Q of clubs			|
			|A of hearts		|
			|2 of hearts		|
			|3 of hearts		|
			|4 of hearts		|
			|5 of hearts		|
			|6 of hearts		|
			|7 of hearts		|
			|8 of hearts		|
			|9 of hearts		|
			|10 of hearts		|
			|J of hearts		|
			|K of hearts		|
			|Q of hearts		|
			|A of spades		|
			|2 of spades		|
			|3 of spades		|
			|4 of spades		|
			|5 of spades		|
			|6 of spades		|
			|7 of spades		|
			|8 of spades		|
			|9 of spades		|
			|10 of spades		|
			|J of spades		|
			|K of spades		|
			|Q of spades		|
			|A of diamonds	|
			|2 of diamonds	|
			|3 of diamonds	|
			|4 of diamonds	|
			|5 of diamonds	|
			|6 of diamonds	|
			|7 of diamonds	|
			|8 of diamonds	|
			|9 of diamonds	|
			|10 of diamonds	|
			|J of diamonds	|
			|K of diamonds	|
			|Q of diamonds	|

## Contributing

1. Fork it ( https://github.com/diegopiccinini/game_shuffle_cards/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
