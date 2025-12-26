require 'cabeza-de-termo/assets-publisher/locations/location'

require_relative 'types/stylesheet-type'
require_relative 'types/javascript-type'

module CabezaDeTermo
	module AssetsPublisher
		# An assets to be included in a template.
		class Asset
			# Answer a new asset on the asset_uri.
			def self.on_uri(asset_type, asset_uri)
				new(asset_type, asset_uri, Location.from(asset_uri))
			end

			# Initialize the instance.
			def initialize(asset_type, asset_uri, location)
				@uri = Pathname.new(asset_uri)
				@type = asset_type
				@location = location
				@real_path = nil
				@uri_parameters = nil
			end

			# Answer the asset uri.
			def uri()
				@uri
			end

			# Answer the asset uri with optional parameters
			def uri_with_parameters()
				return uri.to_s if uri_parameters.nil?

				uri.to_s + '?' + URI.escape(uri_parameters)
			end

			# Answer the asset type
			def type()
				@type
			end

			# Answer the location of the asset
			def location()
				@location
			end

			# Answer the file path of the asset uri.
			def real_path()
				@real_path ||= location.real_path_of(uri)
			end

			def uri_parameters()
				@uri_parameters
			end

			def set_uri_parameters(string)
				@uri_parameters = string
				self
			end

			# Answer the html to include this asset in a template
			def html()
				type.html_for uri_with_parameters
			end

			def validate_real_path()
				raise_asset_not_found_error unless real_path.exist?
			end

			def modification_time()
				return :not_found unless real_path.exist?
				real_path.mtime
			end

			protected

			def raise_asset_not_found_error()
				raise AssetNotFoundError.new(uri)
			end
		end
	end
end