require File.dirname(__FILE__) + '/lib/it_tools/solr'
run Rack::URLMap.new "/" => WebApp