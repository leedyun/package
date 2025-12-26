require 'cabeza-de-termo/assets-publisher/errors/unknown-asset-location-error'

module CabezaDeTermo
	module AssetsPublisher
		class Location
			# Answer a new location for the uri
			def self.from(uri)
				class_for_uri(uri).new(uri)
			end

			# Answer the class to use for the uri
			def self.class_for_uri(uri)
				uri = Pathname.new(uri)

				return class_named("CabezaDeTermo::AssetsPublisher::AbsoluteLocation") if uri.absolute?
				return class_named("CabezaDeTermo::AssetsPublisher::SourceLocation") if uri.relative?

				raise UnknownAssetLocationError.new(uri)
			end

			# Answer a class from its fully quilified name
			def self.class_named(fully_qualified)
				fully_qualified.split('::').inject(Object) do |mod, class_name|
					mod.const_get(class_name)
				end
			end

			# Instance methods

			def initialize(uri)
				@uri = uri
			end

			# Answer the Publisher configuration.
			def configuration
				Publisher.configuration
			end

			# Asking

			def is_absolute?()
				false
			end

			# Answer the path of the asset uri
			def real_path_of(uri)
				CdT.subclass_responsibility
			end
		end
	end
end

require_relative 'source-location'
require_relative 'absolute-location'