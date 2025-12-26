require "admob_site_stats/version"
require 'net/https'
require 'uri'
require 'json'

class AdmobSiteStats

  attr_reader :overall_fill_rate, 
              :exchange_impressions, 
              :interstitial_requests, 
              :fill_rate, 
              :ctr, 
              :housead_requests, 
              :housead_clicks, 
              :impressions, 
              :cpm_revenue, 
              :overall_requests, 
              :requests, 
              :revenue, 
              :housead_ctr, 
              :exchange_downloads, 
              :housead_fill_rate, 
              :date, 
              :cpc_revenue, 
              :clicks, 
              :housead_impressions, 
              :cpm_impressions, 
              :interstitial_impressions, 
              :cpc_impressions, 
              :ecpm 
  
  def initialize (client_key, email, password, site_id_array, start_date, end_date)

    #login and get token
    uri_login = URI.parse("https://api.admob.com/v2/auth/login")

    http = Net::HTTP.new( uri_login.host, uri_login.port )
    http.use_ssl = true if uri_login.port == 443
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if uri_login.port == 443

    request_login = Net::HTTP::Post.new(uri_login.request_uri)
    request_login.set_form_data({"client_key" => client_key, "email" => email, "password" => password })

    begin
      res, data = http.request(request_login)
      hash = JSON.parse res.body
      token = hash['data']['token']
      #TODO catch 500 response codes --- if res.code 

    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
           Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e

           puts e.to_s

    end # end of begin
    
    #login and get token
    uri_stats = URI.parse("https://api.admob.com/v2/site/stats")    
    uri_stats.query = "client_key="+client_key+"&token="+token+"&start_date="+start_date+"&end_date="+end_date
    
    site_id_array.each do |site|
      uri_stats.query = uri_stats.query+"&site_id[]="+site
    end
    
    request_stats = Net::HTTP::Get.new(uri_stats.request_uri)
        
    begin
      res_stats, data_stats = http.request(request_stats)
      hash_stats = JSON.parse res_stats.body
      @overall_fill_rate        = hash_stats["data"][0]["overall_fill_rate"]
      @exchange_impressions     = hash_stats["data"][0]["exchange_impressions"]
      @interstitial_requests    = hash_stats["data"][0]["interstitial_requests"]
      @requests                 = hash_stats["data"][0]["requests"]
      @fill_rate                = hash_stats["data"][0]["fill_rate"]
      @ctr                      = hash_stats["data"][0]["ctr"]
      @housead_requests         = hash_stats["data"][0]["housead_requests"]
      @housead_clicks           = hash_stats["data"][0]["housead_clicks"]
      @impressions              = hash_stats["data"][0]["impressions"]
      @cpm_revenue              = hash_stats["data"][0]["cpm_revenue"]
      @overall_requests         = hash_stats["data"][0]["overall_requests"]
      @requests                 = hash_stats["data"][0]["requests"]
      @revenue                  = hash_stats["data"][0]["revenue"]
      @housead_ctr              = hash_stats["data"][0]["housead_ctr"]
      @exchange_downloads       = hash_stats["data"][0]["exchange_downloads"] 
      @housead_fill_rate        = hash_stats["data"][0]["housead_fill_rate"]
      @date                     = hash_stats["data"][0]["date"]
      @cpc_revenue              = hash_stats["data"][0]["cpc_revenue"]
      @clicks                   = hash_stats["data"][0]["clicks"]
      @housead_impressions      = hash_stats["data"][0]["housead_impressions"]
      @cpm_impressions          = hash_stats["data"][0]["cpm_impressions"]
      @interstitial_impressions = hash_stats["data"][0]["interstitial_impressions"]  
      @cpc_impressions          = hash_stats["data"][0]["cpc_impressions"]
      @ecpm                     = hash_stats["data"][0]["ecpm"]
      
      #TODO catch 500 response codes --- if res.code 

    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
           Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e

           puts e.to_s

    end # end of begin
    
    #login and get token
     uri_logout = URI.parse("https://api.admob.com/v2/auth/logout")
     request_logout = Net::HTTP::Post.new(uri_logout.request_uri)
     request_logout.set_form_data({"client_key" => client_key, "token" => token })

     begin
       res, data = http.request(request_login)
       #TODO catch 500 response codes --- if res.code 

     rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
            Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e

            puts e.to_s

     end # end of begin
            
  end # end of def init

end # end of class
