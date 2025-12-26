require 'rake'
require 'rake/tasklib'
require 'rake/sprocketstask'

module AssetPipeline
  class Tasks < Rake::TaskLib
    def initialize
      namespace :assets do
        desc 'Precompile assets'
        task :precompile do
          manifest = Sprockets::Manifest.new(AssetPipeline.sprockets.index, AssetPipeline.assets_public_path)
          manifest.compile(AssetPipeline.assets_precompile)
        end

        desc 'Clean assets'
        task :clean do
          FileUtils.rm_rf(AssetPipeline.assets_public_path)
        end
      end
    end

    # Installs the tasks
    #
    # @param [Hash] options options
    #   @option options [Array] :clear ([]) Tasks to clear
    #
    # @example Clear previously declared tasks
    #   install(clear: ['assets:precompile', 'assets:clean'])
    #
    def self.install(options = {})
      options.fetch(:clear, []).each { |task| Rake::Task[task].clear}
      self.new
    end
  end
end
