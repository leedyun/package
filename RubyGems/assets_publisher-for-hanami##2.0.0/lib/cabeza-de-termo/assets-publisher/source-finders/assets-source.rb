require 'cabeza-de-termo/assets-publisher/assets/asset'

module CabezaDeTermo
	module AssetsPublisher
		class AssetsSource
			# Class methods

			def self.on(folder)
				new(folder)
			end

			# Instance methods

			def initialize(folder)
				@folder = Pathname.new(folder)
			end

			def folder
				@folder
			end

			def has_asset?(uri)
				asset_path_of(uri).file?
			end

			def asset_path_of(uri)
				folder + uri
			end
		end
	end
end