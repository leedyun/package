require 'json'

describe Rack::EnvInspector do

  RESPONSE_BODY = 'Hello, world'

  let(:app) { lambda { |env| [200, {}, [RESPONSE_BODY]] } }
  let(:stack) { Rack::EnvInspector.new app }
  let(:request) { Rack::MockRequest.new stack }

  it "should return normal response without query param" do
    response = request.get '/'

    expect(response.body).to eq(RESPONSE_BODY)
  end

  it "should return environment dump with query param" do
    response = request.get '/?inspect'
    env = JSON.parse(response.body)

    expect(env["PATH_INFO"]).to eq("/")
    expect(env["QUERY_STRING"]).to eq("inspect")
  end

end
