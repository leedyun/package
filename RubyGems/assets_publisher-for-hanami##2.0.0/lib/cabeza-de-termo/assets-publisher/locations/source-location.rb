require_relative 'location'
require 'cabeza-de-termo/assets-publisher/source-finders/assets-finder'

module CabezaDeTermo
	module AssetsPublisher
		class SourceLocation < Location
			# Answer the path of the asset uri
			def real_path_of(uri)
				(AssetsFinder.asset_source_path_of uri).expand_path
			end
		end
	end
end