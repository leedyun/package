require 'spec_helper'

module PlayingCards
  describe Deck do
    describe ".build" do
      describe "with a shoe size of 1" do
        it "Generates a deck of 52 cards" do
          deck_o_cards = Deck.build
          deck_o_cards.size.must_equal 52
        end
      end

      describe "with a shoe size of 2" do
        it "Generates a deck of 104 cards" do
          deck_o_cards = Deck.build(2)
          deck_o_cards.size.must_equal 104
        end
      end
    end

    describe ".shuffle(cards)" do
      it "will shuffle the deck" do
        unshuffled = Deck.build
        shuffled   = Deck.shuffle(unshuffled)
        shuffled.wont_equal unshuffled
      end
    end

    describe ".cut(cards)" do
      it "will cut the deck" do
        cards    = Deck.build
        top_card = cards[0]
        cards    = Deck.cut(cards)
        top_card.wont_equal cards[0]
      end
    end

    describe "#deal" do
      it "must pop the top card off the deck" do
        cards = Deck.build
        Deck.deal(cards).must_equal [cards[0], cards[1..-1]]
      end
    end

  end

end
