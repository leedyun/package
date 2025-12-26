

module GameShuffleCards
	# This class is the main class to shuffle a deck of cards
	# @author Diego Piccinini Lagos
	class Game
		# the minimun cards per player
		MINIMUN_CARDS = 1

		# the minimun players in a game
		MINIMUN_PLAYERS= 1

		# the default value of players
		PLAYERS = 2

		# the defaul value of cards per player
		CARDS_PER_PLAYER = 3

		# The suit collection of the deck of cards
		SUITS = ['spades', 'hearts', 'diamonds', 'clubs']

		# The cards values collection
		CARDS_VALUES = ['A','2','3','4','5','6','7','8','9','10','J','Q','K']

		# Count total cards in a deck
		TOTAL_CARDS = SUITS.count * CARDS_VALUES.count

		# Maximun players allowed in a Game
		MAXIMUN_PLAYERS = TOTAL_CARDS # the maximun players in a game

		# Initialize the game players and cards per player you want
		# @param players [String|Integer] the number of players in the game
		# @param cards_per_player [String|Integer] the number of cards that will recieve each player
		def initialize(players = PLAYERS, cards_per_player=CARDS_PER_PLAYER)
			# Validate the input params and parse values
			@players, @cards_per_player = ValidateGame.parse_and_validate(players,cards_per_player)

			# The card collection, all the cards in the deck
			@cards_collection = {}

			CARDS_VALUES.each do |card_value|
				SUITS.each do |suit|
					# Create one card and add it to cards_collections
					card = Card.new(card_value,suit)
					@cards_collection[card.id]=card
				end
				# add the cards keys to the cards availables
				@cards_availables= @cards_collection.keys
			end
			# Initialize the maximun possible of cards per player,
			# given a card collection and a number of players
			@maximun_cards_per_player = Game.get_maximun_cards_per_player(@players)

		end
		attr_reader :players, :cards_per_player,  :cards_collection, :maximun_cards_per_player
		attr_accessor :cards_availables

		# Shuffle the deck of cards
		# @return a group of players [Hash] each with their cards
		def results
			players={}
			@players.times do |player|
				players[player]=get_cards
			end
			return players
		end

		# Get cards of the cards still availables in the deck
		# @return group of cards [Array] an array of cards_per_player
		def get_cards
			cards=@cards_availables.sample(@cards_per_player)
			@cards_availables-= cards
			cards
		end

		# Get the maximun of cards per player,
		# given a card collection and a number of players
		# @return maximun cards per player [Integer]
		def self.get_maximun_cards_per_player(players)
			players = ValidateGame.parse_and_validate_players(players)
			TOTAL_CARDS / players
		end
	end
end