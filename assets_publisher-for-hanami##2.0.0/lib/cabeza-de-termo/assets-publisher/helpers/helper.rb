require 'cabeza-de-termo/assets-publisher/publisher'

module CabezaDeTermo
  module AssetsPublisher
  	# The View helper.
  	# To use it, add this to your view:
  	# 
  	# 	module Web
  	# 		module Views
  	# 	    	class YourView
  	# 	      	include CabezaDeTermo::AssetsPublisher::Helper
  	# 	        ...
  	# 	    	end
  	# 	  	end
  	# 	end
  	#
  	# This will publish only one method to your views: #assets_publisher. From that method 
  	# you can call the Publisher protocol.
    module Helper
    	# Answer the Publisher to collect and publish stylesheets and javascripts from
    	# your current view.
    	def assets_publisher
    		Publisher.new
    	end
    end
  end
end