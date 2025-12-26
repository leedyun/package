module ArbSpider
	class ScaleHash < BasicObject

		attr_accessor :help_hash
		attr_accessor :core_hash
		attr_accessor :counter
		attr_accessor :scale

		def initialize(scale=10, *args, &block)
			self.counter ||= -1
			self.scale=scale
			self.help_hash = ::Hash.new
			self.core_hash = ::Hash.new *args, &block
		end

		def method_missing(method, *args, &block)
			begin
				core_hash.send(method, *args, &block) unless hijack_method(method, *args, &block)
			rescue ::NoMethodError => e
				::Kernel.raise ::NoMethodError, "undefined method '#{e.name}' for #{self}"
			end
		end

		#return true to hijack the call of method
		def hijack_method(method, *args, &block)
			case method
			when :'[]=' then
				self.counter += 1
				index = counter % scale
				core_hash.delete(help_hash[index]) if help_hash.include?(index)
				help_hash[index]=args[0] #key
				core_hash[args[0]] = args[1] #value
			else
			end
		end
	end
end
