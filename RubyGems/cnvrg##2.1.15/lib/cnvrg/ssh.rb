require 'fileutils'
require 'cnvrg/files'
require 'net/ssh'


module Cnvrg
  class Ssh
    attr_reader :is_ssh


    def initialize(resp)
      begin
        @is_ssh = false
        sts_path = resp["result"]["sts_path"]

        uri = URI.parse(sts_path)

        http_object = Net::HTTP.new(uri.host, uri.port)
        http_object.use_ssl = true if uri.scheme == 'https'
        request = Net::HTTP::Get.new(sts_path)

        body = ""
        http_object.start do |http|
          response = http.request request
          body = response.read_body
        end

        URLcrypt::key = [body].pack('H*')
        ip = URLcrypt.decrypt(resp["result"]["machine_i"])

        @user = URLcrypt.decrypt(resp["result"]["machine_u"])
        key = URLcrypt.decrypt(resp["result"]["machine_k"])
        @container = URLcrypt.decrypt(resp["result"]["machine_c"])

        tempssh = Tempfile.new "sshkey"
        tempssh.write open(key).read
        tempssh.rewind
        key_path = tempssh.path
        count = 0
        while count < 5

          begin
            @ssh = Net::SSH.start(ip, user=@user, :keys => key_path, :timeout => 10)
            if !@ssh.nil?
              @is_ssh = true
              return
            else
              count+=1
              sleep(2)

            end
          rescue
            count+=1
            sleep(2)


          end
        end
        if tempssh
          tempssh.close
          tempssh.unlink
        end
        return false
      rescue => e

        puts e
      end
    end



    def exec_command(command)
      exec_command = "sudo -i -u #{@user} cnvrg exec_container #{@container} \"#{command}\" "
      return @ssh.exec!(exec_command)
    end


    def close_ssh()


      begin

        @ssh.close
      rescue => e

      end


    end
  end



end
