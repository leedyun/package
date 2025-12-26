require_relative 'asset-type'

module CabezaDeTermo
	module AssetsPublisher
		class JavascriptType < AssetType
			def html_for(asset_uri)
				"<script src=\"#{asset_uri}\" type=\"text/javascript\"></script>"
			end

			# Collect the javascripts uri from the rendering_scope
			def collect_uri_from(rendering_scope)
				rendering_scope_assets_collector.javascripts_from rendering_scope
			end

			def compiler()
				configuration.javascripts_compiler
			end
		end
	end
end