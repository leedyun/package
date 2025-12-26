require 'fileutils'
require 'tilt'
require_relative 'compiler'

module CabezaDeTermo
	module AssetsPublisher
		class TiltCompiler < Compiler
			protected

			def source_asset
				compilation_job.assets.first
			end 

			def compile_assets()
				validate_assets_collection

				compile_single_asset
			end

			def compile_single_asset()
				just_copy? ? copy! : compile!
			end

			def validate_assets_collection()
				raise_compilation_job_not_supported_error unless source_assets.size == 1
			end

			def just_copy?()
				['.css', '.js'].include?(source_asset.real_path.extname)
			end

			def copy!()
				::FileUtils.copy_file(source_asset.real_path, compilation_job.destination_filename)
			end

			def compile!()
				::File.open(compilation_job.destination_filename, 'w') do |file|
					file.write( render_source )
				end
			end

			def render_source()
				Tilt.new(source_asset.real_path).render
			end
		end
	end
end