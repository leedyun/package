require 'fileutils'
require 'open3'
require_relative 'compiler'

module CabezaDeTermo
	module AssetsPublisher
		class CommandLineCompiler < Compiler
			def initialize(&block)
				super()
				@block = block
			end

			def compile_assets()
				@block.call(self, compilation_job)
			end

			def command_line(*args)
				ouput, status = Open3.capture2e(*args)

				raise_compilation_failed_error(ouput.strip) unless status.success?

				ouput
			end
		end
	end
end