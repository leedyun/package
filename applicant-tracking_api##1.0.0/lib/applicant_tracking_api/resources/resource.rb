module ApplicantTracking
	class Resource < ActiveResource::Base
		self.format = :json

		def self.element_name
			name.split(/::/).last.underscore
		end

		def self.method_missing(method, *args, &block)
			if(["active", "hidden", "archived", "rated","unrated"].include?(method.to_s))
				self.find(:all, :from => method.to_sym)
			else
				super
			end
		end
	end
end
