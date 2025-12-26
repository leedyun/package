
module GameShuffleCards

	# @author Diego Hernán Piccinini Lagos
	class Card

		# Create a new card
		# @param card_value [String]
		# @param suit [String]
		def initialize(card_value,suit)
			@id= card_value + ' of ' + suit
			@card_value=card_value
			@suit=suit
		end
		attr_reader	:id, :card_value, :suit, :image

		# Get a image name file
		# @param id [String]
		# @return a file name [String]
		class << self
			def image(id)
				id.tr(' ','_') + '.png'
			end
		end
	end
end