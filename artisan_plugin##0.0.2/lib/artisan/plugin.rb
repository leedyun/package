require "artisan/plugin/version"

module Artisan
  module Plugin
    command "artisan" do
      require_relative "command"
      Command
  end
end
