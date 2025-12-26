require 'net/http'
require 'uri'
require 'sinatra/base'
require 'sanitize'
require 'logger'
require 'erb'
require_relative 'multipart'
require_relative 'shared'

class WebApp < Sinatra::Base
  configure do
    set :public_folder, '/data/documentation/'
    set :environment, :production
    set :port, 80
    set :solr_host, 'localhost'
    set :solr_port, '8983'
    enable :logging, :dump_errors, :raise_errors
  end 
  get '/' do
    "it works!"
  end
  get '/srch' do
    handler = Handler.new
    params[:solr_host] = settings.solr_host
    params[:solr_port] = settings.solr_port
    return "<p>No 'query' specified.</p>" unless params["query"]
    begin
      @highlights = handler.get_srch params
      result = erb :search_results
      return result
    rescue NoResults => reason
      return reason.mesg
    end
  end
  def check_highlights
    retval = "<ul>"
    @highlights.each do |key, value|
      if value['body'].nil? 
        next  
      end
      body = value['body'][0]
      body = body.remove_non_ascii
      clean = Sanitize.clean(body, Sanitize::Config::RELAXED)
      retval += "<li>#{key}<br><div>#{clean}</div>"
    end
    retval += "</ul>"
  end
end
class NoResults < RuntimeError
  attr :mesg
  def initialize(mesg)
    @mesg = mesg
  end
end 


class Handler
  def get_srch params
    query = params["query"]
    if query.nil?
      raise NoResults.new "<p>No Query Specified</p>"
    end
    query = Solr::Query.new params
    resp = query.do_query params
    @highlights = resp['highlighting']
    if @highlights.length == 0 
      raise NoResults.new "<p>No Results</p>"
    end
    return @highlights
  end
end
module Solr
  class Query
    attr_accessor :ops, :log
    def initialize(options = {})
      @ops = {}
      @ops.merge! options unless options.nil?
      @log = Logger.new('log.txt')
      if level = @ops[:debug_level]
        @log.level = level
      else
        @log.level = Logger::DEBUG
      end
      begin
        @ops[:solr_host] = settings.solr_host
      rescue
      end
      mesg = "Must specify ':solr_host' and ':solr_port' in constructor hash"
      raise mesg unless @ops[:solr_host] and @ops[:solr_port]
    end
    def do_query(params)
      h = Net::HTTP.new(@ops[:solr_host], @ops[:solr_port])
      query = params["query"]
      category = params["category"]
      query = "category:" + category + " AND " + params["query"] unless category.nil?
      all = { 
        "q" => URI.escape(query),
        "wt" => "ruby",
        "hl" => "true",
        "hl.fl" => "*"
      }
      query = "/solr/select?"
      all.each do |key, value|
        query += key + "=" + value + "&"
      end
      hresp, data = h.get(query)
      
      if data.nil? 
        return "<p>nothing</p>"
      else
        rsp = eval(data)
        return rsp
      end
    end
  end
  class Upload
    attr_accessor :ops, :debug
    def initialize(options = {})
      @ops = { :debug => true }
      @ops.merge! options
      mesg = 'Missing param.  Example :solr_base_url => "http://192.168.0.22:8983/solr/"' 
      raise mesg unless options[:solr_base_url]
      @log = Logger.new('log.txt')
      if level = @ops[:debug_level]
        @log.level = level
      else
        @log.level = Logger::DEBUG
      end
    end
    def upload_file(filename, data, file_id, search_category)
      params = { 
        "literal.id" => file_id,
        "commit" => "true",
        "uprefix" => "attr_",
        "fmap.content" => "body"
      }
      if @ops[:search_category]
        params["literal.category"] = @ops[:search_category]
      end
      url = @ops[:solr_base_url] + "update/extract"
      @log.debug "[URL]: " + url
      post = Multipart::Post.new
      post.add_params(params)
      post.add_file(filename, data)
      resp = post.post(url)
      case resp
      when Net::HTTPOK
        @log.debug "Successfully submitted file to indexer."
      else
        @log.error "Failed to submit file to indexer."
      end
    end
    def foo
      puts "bar"
    end
  end
end
