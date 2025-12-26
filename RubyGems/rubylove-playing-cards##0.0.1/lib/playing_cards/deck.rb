# encoding: UTF-8
require_relative 'card'

module PlayingCards

  # functional representation of a deck of cards
  module Deck
    extend self

    def build(shoe_size=1)
      build_deck*shoe_size
    end

    def shuffle(cards)
      copy = cards.dup
      copy.sort_by { rand }
    end

    def cut(cards)
      top, bottom = cut_into_2_piles(cards)
      bottom + top # flop that shit
    end

    def deal(cards)
      dealt = cards.first
      [dealt, cards - [dealt]]
    end

  private

    def cut_into_2_piles(cards)
      cut_at = rand(4..cards.length-4) # never cut closer than 4 form the top or bottom
      [cards[0..cut_at-1], cards[cut_at, cards.length-cut_at]]
    end

    def build_deck
      Card::RANKS.flat_map {|rank| Card::SUITS.flat_map {|suit| Card.new(rank, suit) } }
    end

  end
end
