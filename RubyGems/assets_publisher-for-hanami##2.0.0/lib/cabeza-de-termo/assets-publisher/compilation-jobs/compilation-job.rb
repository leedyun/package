require 'cabeza-de-termo/assets-publisher/clock-cards/clock-card'

module CabezaDeTermo
	module AssetsPublisher
		class CompilationJob
			def initialize(assets: nil, destination: nil)
				@assets = assets
				@destination = destination
			end

			# Accessors

			def assets()
				@assets
			end

			def destination()
				@destination
			end

			def id()
				@destination.uri.to_s
			end

			# Asking
			def empty?()
				assets.empty?
			end

			# File names

			def source_filenames
				assets.collect { |asset| asset.real_path.to_s }
			end

			def destination_filename
				destination.real_path.to_s
			end

			# Compiling

			def compile_with(compiler)
				validate_source_assets
				compiler.compile_job self
				self
			end

			# Html

			# Answer the asset html to include in a template.
			def html
				destination.html
			end

			def validate_source_assets()
				assets.each { |asset| asset.validate_real_path }
			end

			# Clock card

			def clock_card()
				ClockCard.new do |card|
					assets.each do |asset|
						card.set_mark_for(asset.uri.to_s, asset.modification_time)
					end

					card.set_mark_for(destination.uri.to_s, destination.modification_time)
				end
			end

			def source_folders()
				configuration.source_folders.collect { |path| Pathname(path).expand_path.to_s }
			end

			def configuration()
				Publisher.configuration
			end
		end
	end
end