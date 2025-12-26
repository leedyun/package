module CabezaDeTermo
	module AssetsPublisher
		# The Publisher configuration.
		class Configuration
			# Initialize the instance
			def initialize
				@source_folders = []

				destination_folder nil
				add_timestamps_to_published_assets true
				stylesheets_compiler {}
				javascripts_compiler {}
				use_rendering_scope_assets_collector nil
			end

			# Answer if the Publisher will add a timestamp to the assets with relative paths
			def add_timestamps_to_published_assets?
				@add_timestamps_to_published_assets
			end

			# Set if the Publisher will add a timestamp to the assets with relative paths
			def add_timestamps_to_published_assets(boolean)
				@add_timestamps_to_published_assets = boolean
			end

			# Answer the asset sources collection
			def source_folders
				@source_folders
			end

			def destination_folder(folder)
				@destination_folder = folder
			end

			def destination_path
				::Pathname.new(@destination_folder)
			end

			def published_assets_subfolder
				::Pathname.new('assets')
			end

			def stylesheets_compiler(&block)
				return @stylesheets_compiler_block.call if block.nil?
				@stylesheets_compiler_block = block
			end

			def javascripts_compiler(&block)
				return @javascripts_compiler_block.call if block.nil?
				@javascripts_compiler_block = block
			end

			def command_line_compiler(&block)
				CommandLineCompiler.new(&block)
			end

			def use_rendering_scope_assets_collector(rendering_scope_assets_collector)
				@rendering_scope_assets_collector = rendering_scope_assets_collector
			end

			def rendering_scope_assets_collector()
				@rendering_scope_assets_collector
			end
		end
	end
end