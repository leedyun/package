require 'asset_pipeline/version'
require 'sprockets'
require 'sprockets-helpers'
require 'asset_pipeline/tasks'

module AssetPipeline
  singleton_class.class_eval do
    attr_accessor :sprockets,
                  :public_folder,
                  :assets_precompile,
                  :assets_paths,
                  :assets_public_path,
                  :assets_protocol,
                  :assets_css_compressor,
                  :assets_js_compressor,
                  :assets_host,
                  :assets_digest,
                  :assets_debug,
                  :path_prefix,
                  :static,
                  :static_cache_control
  end

  self.sprockets             = Sprockets::Environment.new
  self.path_prefix           = '/assets'
  self.public_folder         = 'public'
  self.assets_public_path    = File.join(public_folder, path_prefix)
  self.assets_precompile     = %w(*application.js *application.css *.png *.jpg *.svg *.eot *.ttf *.woff *.woff2)
  self.assets_paths          = %w(assets vendor/assets)
  self.assets_protocol       = nil
  self.assets_css_compressor = nil
  self.assets_js_compressor  = nil
  self.assets_host           = nil
  self.assets_digest         = false
  self.assets_debug          = false

  self.static                = :true
  self.static_cache_control  = [:public, :max_age => 60 * 60 * 24 * 365]

  def self.config
    yield self
    self.assets_public_path = File.join(public_folder, path_prefix)
    self.setup!
  end

  def self.setup!
    assets_paths.each do |raw_path|
      paths = Dir[File.join(raw_path, '*')]
      paths.each { |path| sprockets.append_path path }
    end

    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.prefix      = path_prefix     if path_prefix
      config.digest      = assets_digest
      config.public_path = public_folder   if public_folder
      config.debug       = assets_debug
      config.protocol    = assets_protocol if assets_protocol
      config.asset_host  = assets_host     if assets_host
      config.manifest    = Sprockets::Manifest.new(sprockets, assets_public_path)
    end

    sprockets.css_compressor = assets_css_compressor unless assets_css_compressor.nil?
    sprockets.js_compressor  = assets_js_compressor  unless assets_js_compressor.nil?
  end
end
