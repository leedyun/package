require "application_module/version"
require 'application_module/autoloading'

module ApplicationModule
  autoload :Controller, 'application_module/controller'

  def self.extended(app_module)
    #puts "Loading application module: #{app_module}"
    require 'pathname'
    app_module.instance_variable_set(
      :@path,
      Pathname.new( caller.first[%r{^[^:]+}].sub(%r{\.rb$}, '') )
    )
    app_module.instance_eval do
      extend ApplicationModule::Autoloading
      autoload_without_namespacing %w(
        models
        views
        controllers
        helpers
        concerns
        mailers
      )
    end
  end

  attr_reader :path

  def view_path
    path.join 'views'
  end
end
