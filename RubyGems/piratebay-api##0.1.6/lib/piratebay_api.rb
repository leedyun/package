require 'piratebay_api/version'
require 'rubygems'

require 'fileutils'
require 'net/http'

require 'hpricot'
require 'open-uri'

require 'nokogiri'
require 'uri'

%w(result pirate_bay categories details result_set).each do |filename|
  require File.join(File.dirname(__FILE__), 'piratebay_api', filename)
end

class PiratebayApi
  attr_accessor :service, :search_term, :results, :category

  def initialize(service=:pirate_bay, search_term=nil, url, category)
    @service = service
    @search_term = search_term
    @base_url = url
    @category = category

    @results = search if @search_term
  end

  def search
    if @service == :all
      results = []
      results << PirateBay::Search.new(@search_term, @category, @base_url).execute
      results = results.flatten.sort_by { |sort| -(sort.seeds) }
    else
      case @service
        when :pirate_bay
          handler = PirateBay::Search.new(@search_term, @category, @base_url)
        else
          raise 'You must select a valid service provider'
      end

      results = handler.execute
    end
    @results = results
  end
end
