require 'spec_helper'

describe Apitool::Client::ApitoolClient do
  before(:context) do
    @client = Apitool::Client::ApitoolClient.new({
      host: "127.0.0.1",
      port: 3001,
      ssl: false,
      token: API_KEY,
      version: "v2"
    })
  end

  it "should be possible to establish a connection" do
    expect(@client).to_not be nil
    @client.send(:get, '')
    expect(@client.result).to be 200
  end

end
