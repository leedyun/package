require 'cabeza-de-termo/assets/library'
require 'cabeza-de-termo/assets/rendering-scope-adaptors/hanami-rendering-scope'

module CabezaDeTermo
	module AssetsPublisher
		class AssetType
			def html_for(asset_uri)
				CdT.subclass_responsibility
			end

			# Collect the assets to publish from the rendering_scope
			def collect_assets_from(rendering_scope)
				collect_uri_from(rendering_scope).collect do |uri|
					new_asset_from_uri(uri)
				end
			end

			# Answer a new Asset from the uri and type
			def new_asset_from_uri(uri)
				Asset.on_uri self, uri
			end

			# Collect the javascripts uri from the rendering_scope
			def collect_uri_from(rendering_scope)
				CdT.subclass_responsibility
			end

    		def compiler()
    			CdT.subclass_responsibility
    		end

    		def rendering_scope_assets_collector()
    			configuration.rendering_scope_assets_collector
    		end

			def configuration()
				Publisher.configuration
			end
		end
	end
end