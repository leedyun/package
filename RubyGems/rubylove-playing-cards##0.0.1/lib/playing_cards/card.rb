# encoding: UTF-8


module PlayingCards

  class Card < Struct.new(:rank, :suit)

    SUITS  = %w(hearts clubs spades diamonds).map(&:to_sym)
    RANKS  = %w(ace two three four five six seven eight nine ten jack queen king).map(&:to_sym)
    VALUES = %w(11 2 3 4 5 6 7 8 9 10 10 10 10)
    SBITS  = %w(B D A C)
    RBITS  = %w(1 2 3 4 5 6 7 8 9 A B D E)

    def to_s
      "#{rank.to_s} of #{suit.to_sym}"
    end

    def to_unicode
      ["1F0#{suit_bit}#{rank_bit}".hex].pack("U")
    end
    alias_method :inspect, :to_unicode

    def backside_to_unicode
      "\u{1F0A0}"
    end

    def value
      VALUES[RANKS.index(rank)].to_i
    end

  private

    def suit_bit
      SBITS[SUITS.index(suit)]
    end

    def rank_bit
      RBITS[RANKS.index(rank)]
    end
  end

end

