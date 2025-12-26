require 'arb_spider/version'
require 'arb_spider/spider'

module ArbSpider

	class << self
		attr_accessor :default_spider
	end

	def parse(*args, &block)
		self.class.default_spider ||= ArbSpider::Spider.new
		self.class.default_spider.send :parse *args, &block
	end
end
