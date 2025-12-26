require "ebay/ysr/version"

module Ebay
  require 'net/http'
  require 'json'
  APPID = ''
  class FindingApi

#GET REQUEST
    def self.search(word=nil, categoryId=nil)
      if categoryId == nil
        encode = URI.encode(word)
        puts encode
        url = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=#{APPID.to_s}&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=#{encode.to_s}"
        postData = Net::HTTP.get(URI(url))
        parse = JSON.parse(postData)
        begin
          results = parse['findItemsByKeywordsResponse'][0]['searchResult']
          count = results[0]['@count']
          puts count
          gg = results
          a=0
          items = gg[0]['item']
          return items
        rescue => e
          return items = nil
        end
      elsif word == nil
        categoryId = categoryId
        puts categoryId
        url = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByCategory&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=#{APPID.to_s}&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&categoryId=#{categoryId}"
        postData = Net::HTTP.get(URI(url))
        parse = JSON.parse(postData)
        begin
          results = parse['findItemsByCategoryResponse'][0]['searchResult']
          count = results[0]['@count']
          puts count
          gg = results
          a=0
          items = gg[0]['item']
          return items
        rescue => e
          return items = "Invalid Category Id"
        end
      elsif word != nil && categoryId != nil
        encode = URI.encode(word)
        Rails.logger.info categoryId
        url = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsAdvanced&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=#{APPID.to_s}&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&categoryId=#{categoryId}&keywords=#{encode.to_s}"
        uri = URI.parse(url)
        postData = Net::HTTP.get(uri)
        parse = JSON.parse(postData)
        begin
          results = parse['findItemsAdvancedResponse'][0]['searchResult']
          count = results[0]['@count']
          puts count
          gg = results
          a=0
          items = gg[0]['item']
          return items
        rescue => e
          return items = "Invalid Category Id"
        end
      else
        return nil
      end

#    encode = URI.encode(word)
#    puts encode
#    url = "http://svcs.ebay.com/services/search/FindingService/v1?OPERATION-NAME=findItemsByKeywords&SERVICE-VERSION=1.0.0&SECURITY-APPNAME=#{APPID.to_s}&RESPONSE-DATA-FORMAT=JSON&REST-PAYLOAD&keywords=#{encode.to_s}"
#    postData = Net::HTTP.get(URI(url))
#    parse = JSON.parse(postData)
#    results = parse['findItemsByKeywordsResponse'][0]['searchResult']
#    count = results[0]['@count']
#    puts count
#    gg = results
#    a=0
#    items = gg[0]['item']


# puts items
#    a=0
#    @@items.each do |f|
#      puts a

#      puts "Item Id = #{f['itemId'][0]}
#        Title = #{f['title'][0]}
#        galleryUrl = #{f['galleryURL'][0]}
#        Link = #{f['viewItemURL'][0]}
#        price = #{f['sellingStatus'][0]['currentPrice'][0]['__value__']} #{f['sellingStatus'][0]['currentPrice'][0]['@currencyId']}  "


#      a+=1
#    end


#    return items

    end
  end

end
