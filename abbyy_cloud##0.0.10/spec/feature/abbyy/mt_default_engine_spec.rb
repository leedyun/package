RSpec.describe "mt.default_engine" do
  let(:client)    { ABBYY::Cloud.new id: "foo", token: "bar", engine: "Bing" }
  let(:namespace) { client.mt }
  let(:opts)      { { languages: [], translation_directions: [] } }
  let(:bing)      { ABBYY::Cloud::Models::Engine.new(name: "Bing", **opts) }
  let(:google)    { ABBYY::Cloud::Models::Engine.new(name: "Google", **opts) }

  before  { allow(namespace).to receive(:engines) { [bing, google] } }
  subject { namespace.default_engine }

  it { is_expected.to eql bing }
end
