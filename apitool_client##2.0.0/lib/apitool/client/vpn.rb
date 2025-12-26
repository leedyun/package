class Apitool::Client::Vpn < Apitool::Client::ApitoolClient

  def index
    get('/vpns') do |response, request, result|
      if response.code == 200
        parse(response)
      else
        nil
      end
    end
  end

  def show(uuid)
    get("/vpns/#{uuid}") do |response|
      if response.code == 200
        parse(response)
      else
        nil
      end
    end
  end

  # {
  #   uuid: "some unique identifier",
  #   identifier: "email@domain.com"
  # }
  def create(options = {})
    parameters = {
      vpn: options
    }
    post("/vpns", parameters) do |response|
      if response.code == 200
        parse(response)
      else
        nil
      end
    end
  end

  def destroy(uuid)
    delete("/vpns/#{uuid}") do |response|
      if response.code == 200
        parse(response)
      else
        nil
      end
    end
  end

end
