require 'active_record'
require 'active_support/inflector'
require 'acts_as_explorable/version'
require 'acts_as_explorable/configuration'
require 'acts_as_explorable/parser'
require 'acts_as_explorable/ext/string'
require 'acts_as_explorable/element'
require 'acts_as_explorable/explorable'
require 'acts_as_explorable/query'

#
# ActsAsExplorable Plugin
#
# @author hiasinho
#
module ActsAsExplorable
  def self.extended(base)
    base.extend Query
  end

  def self.method_missing(method_name, *args, &block)
    if @configuration.respond_to?(method_name)
      @configuration.send(method_name, *args, &block)
    else
      super
    end
  end

  def self.respond_to?(method_name, _include_private = false)
    @configuration.respond_to? method_name
  end

  protected

  def self.setup
    @configuration ||= Configuration.new
    yield @configuration if block_given?
  end

  setup
end

ActiveSupport.on_load(:active_record) do
  extend ActsAsExplorable::Explorable
end
