require 'warning'
Warning.ignore(/.*::CompositeIO is deprecated.*/)
Warning.ignore(/.*::Parts is deprecated.*/)
Warning.ignore(/.*::UploadIO is deprecated.*/)
require 'rubygems'
require 'cnvrg/version'
require 'cnvrg/cli'
require 'thor'

module Cnvrg
end
