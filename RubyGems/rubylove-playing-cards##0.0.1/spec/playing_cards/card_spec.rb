require 'spec_helper'

module PlayingCards

  describe Card do
    describe "#to_s" do
      it "must describe the card" do
        Card.new(:ace, :hearts).to_s.must_equal "ace of hearts"
      end
    end

    describe "#to_unicode" do
      it "must show the card in unicode" do
        Card.new(:ace, :hearts).to_unicode.must_equal "\u{1F0B1}"
      end
    end

    describe "#backside_to_unicode" do
      it "must show the card backside in unicode" do
        Card.new(:ace, :hearts).backside_to_unicode.must_equal "\u{1F0A0}"
      end
    end

    describe "#value" do
      it "must be 11 when ace" do 
        Card.new(:ace, :spades).value.must_equal 11
      end
      it "must be 2 when two" do 
        Card.new(:two, :spades).value.must_equal 2
      end
      it "must be 3 when three" do 
        Card.new(:three, :spades).value.must_equal 3
      end
      it "must be 4 when four" do 
        Card.new(:four, :spades).value.must_equal 4
      end
      it "must be 5 when five" do 
        Card.new(:five, :spades).value.must_equal 5
      end
      it "must be 6 when six" do 
        Card.new(:six, :spades).value.must_equal 6
      end
      it "must be 7 when seven" do 
        Card.new(:seven, :spades).value.must_equal 7
      end
      it "must be 8 when eight" do 
        Card.new(:eight, :spades).value.must_equal 8
      end
      it "must be 9 when nine" do 
        Card.new(:nine, :spades).value.must_equal 9
      end
      it "must be 10 when jack" do 
        Card.new(:jack, :spades).value.must_equal 10
      end
      it "must be 10 when queen" do 
        Card.new(:queen, :spades).value.must_equal 10
      end
      it "must be 10 when king" do 
        Card.new(:king, :spades).value.must_equal 10
      end
    end
  end

end
