RSpec.describe "mt.engine" do
  let(:client)    { ABBYY::Cloud.new id: "foo", token: "bar" }
  let(:namespace) { client.mt }
  let(:opts)      { { languages: [], translation_directions: [] } }
  let(:bing)      { ABBYY::Cloud::Models::Engine.new(name: "Bing", **opts) }
  let(:google)    { ABBYY::Cloud::Models::Engine.new(name: "Google", **opts) }

  before { allow(namespace).to receive(:engines) { [bing, google] } }

  it "works" do
    expect(namespace.engine("Bing")).to eq bing
    expect(namespace.engine("Google")).to eq google
    expect(namespace.engine("Unknonw")).to be_nil
  end
end
