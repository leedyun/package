require_relative 'error'

module CabezaDeTermo
	module AssetsPublisher
		class AssetNotFoundError < Error
			def initialize(asset_uri)
				super("The asset '#{asset_uri}' was not found.")
				@asset_uri = asset_uri
			end
		end
	end
end