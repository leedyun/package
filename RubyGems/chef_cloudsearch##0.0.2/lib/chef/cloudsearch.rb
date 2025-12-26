require 'chef/cloudsearch/version'

require 'chef/recipe'
require 'chef/resource'
require 'chef/provider'

class Chef
  module Cloudsearch
    #require_relative 'cloudsearch/plugin'
    require_relative 'cloudsearch/awssearch'
  end
end

Chef::Recipe.send(:include, Chef::Cloudsearch::DSL)
Chef::Resource.send(:include, Chef::Cloudsearch::DSL)
Chef::Provider.send(:include, Chef::Cloudsearch::DSL)
