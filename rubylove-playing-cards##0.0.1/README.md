# Usage

```ruby
require 'playing_cards'

cards = Deck.build                   # defaults to a shoe_size of 1
cards = Deck.shuffle(cards)          # shuffle!
cards = Deck.cut(cards)              # cut the cards!
dealt, cards = Deck.deal(cards)      # => [top_card, rest_of_the_cards]

```

## Health

[![Build
Status](https://travis-ci.org/thatrubylove/functional_playing_cards.png)](https://travis-ci.org/thatrubylove/functional_playing_cards)
[![Coverage
Status](https://coveralls.io/repos/thatrubylove/functional_playing_cards/badge.png?branch=master)](https://coveralls.io/r/thatrubylove/functional_playing_cards?branch=master)
[![CodeClimate
Grade](https://codeclimate.com/repos/52ce0d1de30ba02b1a000f26/badges/c216141a5d36245d2f4e/gpa.png)](https://codeclimate.com/repos/52ce0d1de30ba02b1a000f26/code)
