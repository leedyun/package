class Apitool::Client::Backup < Apitool::Client::ApitoolClient

  def path_to_b64_path(path)
    Base64.strict_encode64(path)
  end

  def index
    get('/backups') do |response, request, result|
      if response.code == 200
        parse(response)
      else
        nil
      end
    end
  end

  def show(uuid)
    get("/backups/#{uuid}") do |response|
      if response.code == 200
        parse(response)
      else
        nil
      end
    end
  end

  # {
  #   uuid: "some unique identifier",
  #   b64_path: "some_path_encrypted_in_b64"
  # }
  def create(options = {})
    parameters = {
      backup: options
    }
    post("/backups", parameters) do |response|
      if response.code == 200
        parse(response)
      else
        nil
      end
    end
  end

  def destroy(uuid)
    delete("/backups/#{uuid}") do |response|
      if response.code == 200
        parse(response)
      else
        nil
      end
    end
  end

end
