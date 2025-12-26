require "alphabetic_paginate/version"

module Alphabetic_paginate  
	module Rails
		class Engine < ::Rails::Engine
    	    add_paths_block = lambda { |app|
		      app.config.assets.paths << File.expand_path("../app/assets/javascripts", __FILE__)

		      # Ensure Zepto and Modernizr are precompiled in production
		      # app.configassets.precompile += %w(vendor/zepto.js vendor/custom.modernizr.js)
		    }

		    # Standard initializer
		    initializer 'alphabetic_paginate.update_asset_paths', &add_paths_block

		    # Special initializer lets us precompile assets without fully initializing
		    initializer 'alphabetic_paginate.update_asset_paths', :group => :assets,
		                &add_paths_block
    	end
	end
end

