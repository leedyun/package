require 'fileutils'
require 'tilt'
require 'cabeza-de-termo/assets-publisher/errors/compilation-job-not-supported-error'
require 'cabeza-de-termo/assets-publisher/errors/compilation-job-failed-error'

module CabezaDeTermo
	module AssetsPublisher
		class Compiler
			def compile_job(compilation_job)
				return if compilation_job.empty?

				@compilation_job = compilation_job

				ensure_destination_folder_exists

				compile_assets
			end

			def compilation_job()
				@compilation_job
			end

			def source_assets()
				@compilation_job.assets
			end

			protected

			def compile_assets()
				CdT.subclass_responsibility
			end

			def ensure_destination_folder_exists()
				destination_folder.mkpath
			end

			def destination_folder()
				compilation_job.destination.real_path.dirname
			end

			def raise_compilation_job_not_supported_error()
				raise CompilationJobNotSupportedError.new(self, compilation_job)
			end

			def raise_compilation_failed_error(message)
				raise CompilationJobFailedError.new(self, compilation_job, message)
			end
		end
	end
end