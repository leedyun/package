module CabezaDeTermo
	module AssetsPublisher
		class CompilationJobsBuilder
			# Answer a new collection of compilation jobs for the assets
			def self.jobs_for(asset_type, assets)
				self.new(asset_type).jobs_for(assets)
			end

			def jobs_for(assets)
				CdT.subclass_responsibility
			end

			# Initializing

			def initialize(asset_type)
				@asset_type = asset_type
			end

			# Accessing

			def asset_type()
				@asset_type
			end

			# Configuration

			# Answer the Publisher configuration.
			def configuration
				Publisher.configuration
			end

			def compiled_assets_folder
				configuration.published_assets_subfolder
			end

			# Answer the uri of the compiled asset
			def compiled_uri
				Pathname.new('/') + compiled_assets_folder + compiled_filename
			end

			def compiled_filename
				CdT.subclass_responsibility
			end

			# Published asset

			def asset_to_publish()
				Asset.on_uri(asset_type, compiled_uri)
			end
		end
	end
end