require 'cdt/utilities/bind'
require 'cdt/utilities/subclass-responsibility'
require 'cdt/utilities/if-not-nil'
require_relative 'version'
require_relative 'configuration/configuration'
require_relative 'assets/asset'
require_relative 'compilation-jobs/one-file-per-asset-builder'
require_relative 'compilers/tilt-compiler'
require_relative 'compilers/command-line-compiler'
require_relative 'clock-cards/clock-card-machine'

module CabezaDeTermo
	module AssetsPublisher
		# The collector and publisher of the stylesheets and javascripts from the current view.
		class Publisher

			@configuration_prototype = nil

			@clock_card_machine = ClockCardMachine.new

			@configurations_per_thread = {}

			# Class methods
			class << self
				# Answer the Publihser configuration
				def configuration()
					configurations_per_thread[::Thread.current]
				end

				# Pass the config to the block to allow the app to configure the Publisher
				def configure(&block)
					CdT.bind_block_evaluation_to configuration_prototype, &block
				end

				def clock_card_machine()
					@clock_card_machine
				end

				def configurations_per_thread()
					@configurations_per_thread
				end

				# Answer the Publihser configuration
				def configuration_prototype()
					@configuration_prototype ||= default_configuration
				end

				def reset_configuration_prototype()
					@configuration_prototype = nil
				end

				def default_configuration()
					CdT.bind_block_evaluation_to(Configuration.new) do
						add_timestamps_to_published_assets true

						stylesheets_compiler { TiltCompiler.new }
						javascripts_compiler { TiltCompiler.new }

						use_rendering_scope_assets_collector CabezaDeTermo::Assets::HanamiRenderingScope

						self
					end
				end
			end

			# Instance methods

			# Collect and publish the stylesheets from the rendering_scope. Answer the html to include
			# in your template.
			def stylesheets_for(rendering_scope)
				with_configuration_copy do
					compile_and_build_html_for(StylesheetType.new, rendering_scope)
				end
			end

			# Collect and publish the javascripts from the rendering_scope. Answer the html to include
			# in your template.
			def javascripts_for(rendering_scope)
				with_configuration_copy do
					compile_and_build_html_for(JavascriptType.new, rendering_scope)
				end
			end

			protected

			def compile_and_build_html_for(asset_type, rendering_scope)
				compile_assets_and_build_html_for asset_type, assets_for(asset_type, rendering_scope)
			end

			def compile_assets_and_build_html_for(asset_type, assets)
				jobs = compilation_jobs_for(asset_type, assets)

				compile_jobs(asset_type, jobs)
				jobs_html(jobs)
			end

			def compile_jobs(asset_type, compilation_jobs)
				compilation_jobs.each do |job|
					compile(job, asset_type)
				end
			end

			def compile(compilation_job, asset_type)
				return unless clock_card_machine.is_outdated? compilation_job

				compilation_job.compile_with(asset_type.compiler)

				clock_card_machine.register_modifications_on compilation_job
			end

			def jobs_html(compilation_jobs)
				compilation_jobs.inject('') do |html, compilation_job|
					html += compilation_job.html
				end
			end

			# Create and answer a new comopilation job
			def compilation_jobs_for(asset_type, assets)
				OneFilePerAssetBuilder.jobs_for asset_type, assets
			end

			def assets_for(asset_type, rendering_scope)
				asset_type.collect_assets_from(rendering_scope)
			end

			def clock_card_machine()
				self.class.clock_card_machine
			end

			def with_configuration_copy(&block)
				begin
					self.class.configurations_per_thread[::Thread.current] = 
						self.class.configuration_prototype.dup

					block.call
				ensure
					self.class.configurations_per_thread.delete(::Thread.current)
				end
			end
		end
	end
end