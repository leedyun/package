require "commission_junction_stats/version"
require 'net/https'
require 'uri'
require 'nokogiri'

class CommissionJunctionStats
  
  attr_reader :total_revenue, :total_revenue_by_advertiser
  
  # Your code goes here...
  def initialize (authorization_token, start_date, end_date)

    @total_revenue = 0
    @total_revenue_by_advertiser = Hash.new

    # set-up API calls 
    uri = "https://commission-detail.api.cj.com/v3/commissions"
    uri = URI.parse( uri )
    uri.query = "date-type=event&start-date=" + start_date + "&end-date=" + end_date

    http = Net::HTTP.new( uri.host, uri.port )
    http.use_ssl = true 
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE 

    request = Net::HTTP::Get.new(uri.request_uri)
    request["Authorization"] = authorization_token
    
    begin

      res, data = http.request(request)

      #TODO catch 500 response codes --- if res.code 

      doc = Nokogiri::XML(data)

      set = doc.xpath("//commissions/commission/commission-amount")
      set.each do |amount|
          # add to hash
          @total_revenue += amount.text.to_f
      end

      by_ad = doc.xpath("//commissions/commission")
      by_ad.each do |commission|
          # add to hash
          (@total_revenue_by_advertiser[commission.xpath('advertiser-name').text.to_s] ||= []) << commission.xpath('commission-amount').text.to_f
      end

    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
           Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e

           puts e.to_s

    end

  end
  
end
