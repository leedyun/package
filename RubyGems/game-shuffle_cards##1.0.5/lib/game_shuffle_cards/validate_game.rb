
module GameShuffleCards
	# @author Diego Hernán Piccinini Lagos
	# validation to secure the inputs of the Game
	class ValidateGame
		class << self
			# Given two values String or Integer, checks whether they are valid in a context Game
			# then return the integers values or raise an exception
			# @param players [String|Integer]
			# @param cards_per_player [String|Integer]
			# @return players and cards per player [Array] with integers values of each one
			def parse_and_validate(players, cards_per_player)
				begin
					players = Integer(players)
					cards_per_player= Integer(cards_per_player)

				rescue
					raise TypeError
				end
				raise GameShuffleCards::ToManyPlayersError if players > GameShuffleCards::Game::MAXIMUN_PLAYERS
				raise GameShuffleCards::NotEnoughPlayersError if players < GameShuffleCards::Game::MINIMUN_PLAYERS
				raise GameShuffleCards::ToManyCardsPerPlayerError if cards_per_player > GameShuffleCards::Game::TOTAL_CARDS
				raise GameShuffleCards::NotEnoughCardsPerPlayersError if cards_per_player < GameShuffleCards::Game::MINIMUN_CARDS
				raise GameShuffleCards::TooManyCardsDemandedError if (players * cards_per_player) > GameShuffleCards::Game::TOTAL_CARDS
				[players,cards_per_player]
			end

			# Validates whether the amount and type of players are right. Otherwise raise an exception
			# @param players [String|Integer]
			# @return number of players [Integer]
			def parse_and_validate_players(players)
				begin
					players = Integer(players)
				rescue
					raise TypeError
				end
				raise GameShuffleCards::ToManyPlayersError if players > GameShuffleCards::Game::MAXIMUN_PLAYERS
				raise GameShuffleCards::NotEnoughPlayersError if players < GameShuffleCards::Game::MINIMUN_PLAYERS
				players
			end
		end
	end
end