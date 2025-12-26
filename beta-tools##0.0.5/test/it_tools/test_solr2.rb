require "test/unit"
require_relative "../../lib/it_tools/solr"

#  args = {
#    :solr_host => "searcher",
#    :solr_port => "8983" }
#  query = Solr::Query.new args
#  params = { 
#    "query" => "arch", 
#    "category" => "public" }
#  resp = query.do_query params
#  p resp

handler = Handler.new 
params = {                
  "query" => "arch",      
  "category" => "public",
  :solr_host => "searcher",  
  :solr_port => "8983" }     

resp = handler.get_srch params
p resp
