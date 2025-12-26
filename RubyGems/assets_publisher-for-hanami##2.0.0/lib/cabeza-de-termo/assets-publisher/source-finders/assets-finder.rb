require 'cabeza-de-termo/assets-publisher/source-finders/assets-source'
require 'cabeza-de-termo/assets-publisher/errors/asset-not-found-error'

module CabezaDeTermo
	module AssetsPublisher
		class AssetsFinder
			# Class methods

			# Search for the asset uri in the configured sources
			def self.asset_source_path_of(uri)
				new.asset_source_path_of(uri)
			end

			# Instance methods

			# Search for the stylesheet uri in the configured sources
			def asset_source_path_of(uri)
				find_source_cotaining(uri).asset_path_of(uri)
			end

			protected

			def find_source_cotaining(uri)
				sources.detect(proc{ raise_asset_not_found_error(uri) }) do |each_source|
					each_source.has_asset?(uri)
				end
			end

			def sources
				configuration.source_folders.collect { |folder| AssetsSource.on(folder) }
			end

			# Answer the Publisher configuration.
			def configuration
				Publisher.configuration
			end

			# Raise an asset not found error
			def raise_asset_not_found_error(asset_uri)
				raise AssetNotFoundError.new(asset_uri)
			end
		end
	end
end