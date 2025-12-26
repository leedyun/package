$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'irb'
require 'logger'
require 'rubygems'
require 'active_support/all'
require 'mapper/schema'
require 'mapper/class_template'
require 'mapper/class_definition'

ActiveSupport::Inflector.inflections.plurals.delete_if{|inflection| inflection.first == /([^aeiouy]|qu)ies$/i }