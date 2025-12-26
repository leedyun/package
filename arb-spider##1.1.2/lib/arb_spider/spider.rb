require 'httpclient'
require 'nokogiri'
require 'arb_spider/scale_hash'

module ArbSpider
	class Spider < BasicObject

		attr_reader :cached_docs
		attr_reader :current_doc
		attr_reader :client

		def initialize
			@client= ::HTTPClient.new
			@cached_docs = ScaleHash.new 20

			#after initializing
			yield self if ::Kernel.block_given?
		end

		def parse(url=nil, *args, &block)
			tmp_doc = url.nil? ? current_doc : (@cached_docs[url] || fetch_doc(url, *args))
			::Kernel.raise StandardError, "fail to load doc of specific url #{url}" if tmp_doc.nil?
		end

		def method_missing(method, *args, &block)
			#used to support user authorization through httpclient method (eg post)
			tmp = @client.send method, *args, &block
			@current_doc = tmp if ::HTTP::Message === tmp
		rescue ::NoMethodError => e
			@current_doc.send method, *args, &block
		rescue ::NoMethodError => e
			::Kernel.raise ::NoMethodError, "undefined method '#{e.name}' for #{self}"
		end

		def inspect
			klass = class << self
						self
					end
			'<%s:%d>' % [klass.superclass.name, self.__id__]
		end

		private

		def fetch_doc(url, *args)
			tmp_args = args.dup
			tmp_doc = client.send(parse_args(:method) {} || :get, *args) #default to use get method
			cached_docs[url] = tmp_doc
		end

		def parse_args (key, source=nil, &block)
			raise ArgumentError, 'please provide either arguments source or a block with which the local variables bind! (eg parse_args{}) ' unless source || block
			args_arr = source || block.binding.local_variables.map { |i|
				block.binding.local_variable_get i
			}
			args_hash = args_arr && args_arr.find do |i|
				Hash == i # or i.respond_to? :"[]"
			end
			raise ArgumentError, 'no arguments hash found in current hash, please provide the proper source ' if args_arr.nil?
			args_hash.delete key
		end

	end
end
