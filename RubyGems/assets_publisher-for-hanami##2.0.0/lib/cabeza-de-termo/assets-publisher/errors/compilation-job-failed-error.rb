require_relative 'error'

module CabezaDeTermo
	module AssetsPublisher
		class CompilationJobFailedError < Error
			def initialize(compiler, compilation_job, message)
				super(message)

				@compiler = compiler
				@compilation_job = compilation_job
			end
		end
	end
end