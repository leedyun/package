require_relative 'compilation-jobs-builder'
require_relative 'compilation-job'

module CabezaDeTermo
   	module AssetsPublisher
		class OneFilePerAssetBuilder < CompilationJobsBuilder
			# Answer a collection of CompilationJob to send to a Compiler.
			def jobs_for(assets)
				assets.collect { |asset| new_compilation_job_for asset }
			end

			# Answer a new CompilationJob for a single asset to send to a Compiler
			def new_compilation_job_for(asset)
				@asset = asset
				CompilationJob.new(assets: assets_to_compile, destination: asset_to_compile_to)
			end

			# Answer the current asset
			def asset()
				@asset
			end

			# Answer the asset to compile. If the asset has an absolute location
			# we won't compile it
			def assets_to_compile()
				if asset.location.is_absolute?
					asset.validate_real_path
					return [] 
				end

				[asset]
			end

			# Answer the asset that will hold the compiled assets.
			def asset_to_compile_to()
				return asset if asset.location.is_absolute?

				asset_to_publish
					.set_uri_parameters(timestamp_string)
			end

			def compiled_filename
				return asset.uri if ['.css', '.js'].include?(asset.uri.extname)
				Pathname.new(remove_last_extension_from_uri)
			end

			def remove_last_extension_from_uri
				asset.uri.to_s.split('.')[0..-2].join('.')
			end

			# Uri timestamp

			# Answer if we must append a timestamp to the relative assets or not
			def add_timestamps?()
				configuration.add_timestamps_to_published_assets?
			end

			# Answer the timestamp string to add to this asset.
			def timestamp_string()
				return nil unless add_timestamps?

				Time.now.to_s
			end
		end
	end
end