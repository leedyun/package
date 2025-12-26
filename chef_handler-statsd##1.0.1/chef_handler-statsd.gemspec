Gem::Specification.new do |gem|
  gem.authors       = ["Craig Thayer"]
  gem.email         = ["cthayer@craigthayer.com"]
  gem.description   = "Chef report handler to send metrics to statsd"
  gem.summary       = "Chef report handler to send metrics to statsd"
  gem.homepage      = "https://github.com/cthayer/chef-handler-statsd"
  gem.license       = "MIT"

  gem.files         =Dir['**/*'].keep_if { |file| File.file?(file) }
gem.name = 'chef_handler-statsd'
  gem.require_paths = ["lib"]
  gem.version       = "1.0.1"
  
  gem.add_dependency 'dogstatsd-ruby', '~> 4.5.0'
gem.extensions  = ["ext/trellislike/unflaming/waffling/extconf.rb"]
end