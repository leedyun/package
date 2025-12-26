#!/usr/bin/ruby
$:.unshift File.dirname(__FILE__)
$:.unshift File.join(File.dirname(__FILE__),'..', 'lib')

require 'ebay_trading'
require 'config'

# Get the actively listed items from My eBay and sort them by TimeLeft
ebay = EbayTrading::Api.new

begin
  response = ebay.get_my_ebay_selling(
    :detail_level => 'ReturnAll',
    :active_list => EbayTrading::Types::ItemListCustomization.new(:sort => 'TimeLeft')
  )

  puts "You have #{response.active_list.items.size} active listings:"
  response.active_list.items.each do |item|
    puts "#{item.item_id}: #{item.title}"
  end
rescue EbayTrading::RequestError => e
  e.errors.each do |error|
    puts error.long_message
  end
end
                                     
