module CabezaDeTermo
	module AssetsPublisher
		# An object to detect if a compilation job needs to run or not.
		class ClockCardMachine
			def initialize()
				@clock_cards = {}
			end

			def is_outdated?(compilation_job)
				return true unless has_record_on?(compilation_job.id)

				clock_cards_not_match? clock_cards[compilation_job.id], compilation_job.clock_card
			end

			def register_modifications_on(compilation_job)
				clock_cards.delete(compilation_job.id)

				CdT.object compilation_job.clock_card,
					if_not_nil: proc { |card| clock_cards[compilation_job.id] = card unless card.has_assets_missing? }
			end

			protected

			def clock_cards
				@clock_cards
			end

			def has_record_on?(id)
				clock_cards.key?(id)
			end

			def clock_cards_not_match?(expected_card, card)
				!clock_cards_match?(expected_card, card)
			end

			def clock_cards_match?(expected_card, card)
				return false unless expected_card.size == card.size

				expected_card.all_marks? { |uri, time| time == card.time_for(uri) }
			end
		end
	end
end