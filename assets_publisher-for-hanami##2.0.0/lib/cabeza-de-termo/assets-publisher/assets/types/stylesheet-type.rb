require_relative 'asset-type'

module CabezaDeTermo
	module AssetsPublisher
		class StylesheetType < AssetType
			def html_for(asset_uri)
				"<link href=\"#{asset_uri}\" type=\"text/css\" rel=\"stylesheet\">"
			end

			# Collect the javascripts uri from the rendering_scope
			def collect_uri_from(rendering_scope)
				rendering_scope_assets_collector.stylesheets_from rendering_scope
			end

			def compiler()
				configuration.stylesheets_compiler
			end
		end
	end
end