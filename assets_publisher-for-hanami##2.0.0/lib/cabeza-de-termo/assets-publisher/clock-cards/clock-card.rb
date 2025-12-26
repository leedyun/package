module CabezaDeTermo
	module AssetsPublisher
		class ClockCard
			def initialize(&block)
				@marks = {}

				block.call(self)
			end

			# Accesing

			def set_mark_for(asset_uri, time)
				marks[asset_uri] = time
			end

			def time_for(asset_uri)
				marks[asset_uri]
			end

			# Asking

			def has_time_for?(asset_uri)
				marks.key?(asset_uri)
			end

			def all_marks?(&block)
				marks.all?(&block)
			end

			def has_assets_missing?()
				marks.any? { |uri, timestamp| timestamp == :not_found }
			end

			# Querying

			def size()
				marks.size
			end

			protected

			def marks()
				@marks
			end
		end
	end
end