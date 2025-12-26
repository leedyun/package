

module GameShuffleCards
	class ToManyPlayersError < RangeError; end
	class NotEnoughPlayersError < RangeError; end
	class ToManyCardsPerPlayerError < RangeError; end
	class NotEnoughCardsPerPlayersError < RangeError; end
	class TooManyCardsDemandedError < RangeError; end
end