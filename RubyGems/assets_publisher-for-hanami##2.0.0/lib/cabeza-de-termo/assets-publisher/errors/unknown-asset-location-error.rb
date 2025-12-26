require_relative 'error'

module CabezaDeTermo
	module AssetsPublisher
		class UnknownAssetLocationError < Error
			def initialize(asset_uri)
				super("Unkown location for '#{asset_uri}'.")
				@asset_uri = asset_uri
			end
		end
	end
end