require "cli"
require "cli/core_ext"

module Bosh
  module PluginGenerator
    include BoshExtensions
  end
end

require "bosh/plugin_generator/generator"
require "bosh/plugin_generator/helpers"
require "bosh/cli/commands/plugin_generator"
