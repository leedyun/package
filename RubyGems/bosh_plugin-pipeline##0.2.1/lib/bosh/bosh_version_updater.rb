require 'cli'
require 'cli/core_ext'
require 'bosh-versions'

module Bosh
  module BoshVersionUpdater
    include BoshExtensions
  end
end

require "bosh/bosh_version_updater/helpers"
