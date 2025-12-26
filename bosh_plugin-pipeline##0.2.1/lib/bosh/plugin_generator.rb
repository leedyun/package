require "cli"
require "cli/core_ext"

module Bosh
  module PluginGenerator
    include BoshExtensions
  end
end

require "bosh/template_generator/generator"
require "bosh/plugin_generator/helpers"
