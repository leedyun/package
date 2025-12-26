require_relative '../lib/it_tools/publisher2'
require 'fileutils'
require 'logger'

FileUtils.touch '../testdata/src_dir/file1.mmd'
FileUtils.rm_rf '../testdata/target_dir/file4.html'
FileUtils.rm_rf '../testdata/target_dir/images'

solr_search_files = [ "search.html",
                      "search.js",
                      "ajax-loader.gif",
                      "help.png" ]
                     
parameters = { 
  :indexer_url => "http://127.0.0.1:8983/solr/",
  :style_sheet => "inputStyles.css",
  :solr_search_files => solr_search_files,
  :src_dir => '../testdata/src_dir',
  :target_dir => '../testdata/target_dir',
  :debug_level => Logger::DEBUG
 }

publisher = Publisher::Markdown.new parameters
publisher.process_files
