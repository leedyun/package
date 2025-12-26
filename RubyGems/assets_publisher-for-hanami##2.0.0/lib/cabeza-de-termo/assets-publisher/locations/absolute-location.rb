require_relative 'location'

module CabezaDeTermo
	module AssetsPublisher
		class AbsoluteLocation < Location
			# Answer the path of the asset uri.
			def real_path_of(uri)
				Pathname.new(destination_path.to_s + uri.to_s).expand_path
			end

			# Asking

			def is_absolute?()
				true
			end

			protected

			# Answer the path of the folder where compiled assets are published
			def destination_path
				configuration.destination_path
			end
		end
	end
end
