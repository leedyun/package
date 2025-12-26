require 'socket'  
require 'timeout'
require 'net/http'

module NetworkTools
  class VpnTools
    def is_port_open?(ip, port)
      begin
        Timeout::timeout(1) do
          begin
            s = TCPSocket.new(ip, port)
            s.close
            return true
          rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
            return false
          end
        end
      rescue Timeout::Error
      end
      return false
    end

    # * *Returns* :
    #   - true if you are on the vpn or false if you are not on the vpn
    def on_vpn
      if is_port_open?("spicevan.com", 22)
        return false
      else
        return true
      end
    end

    def login_to_url2(url, port, username, password, limit = 35)
      puts "[URL]: " + url
      puts "[PORT]: #{port}"
      puts "[USERNAME]: " + username
      puts "[PASSWORD]: " + password

      # You should choose a better exception.
      raise ArgumentError, 'too many HTTP redirects' if limit == 0

      uri = URI(url)

      req = Net::HTTP::Get.new(uri.request_uri)
      req.basic_auth username, password

      res = Net::HTTP.start(uri.host, port, :use_ssl => uri.scheme == 'https') {|http|
        http.request(req)
      }

      case res
      when Net::HTTPSuccess then
        puts "Successfully logged in." # res.body
      when Net::HTTPRedirection then
        location = res['location']
        warn "redirected to #{location}"
        login_to_url2(location, port, username, password, limit - 1)
      else
        response.value
      end
#    File.open('out.html', 'w'){|f| f.write res.body}
      puts res.body.to_s
    end


  end
end

