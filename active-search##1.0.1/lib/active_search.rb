require "active_search/version"
require "active_record"

['search_helper.rb', 'is_searchable.rb'].each { |path| Dir["#{File.dirname(__FILE__)}/active_search/#{path}"].each { |f| require(f) } }

ActiveRecord::Base.send :include, ActiveSearch::SearchHelper
