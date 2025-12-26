RSpec.describe "mt.engines" do
  let(:client)   { ABBYY::Cloud.new settings }
  let(:settings) { { id: "foo", token: "bar" } }
  let(:path)     { "https://api.abbyy.cloud/v0/mt/engines" }
  let(:response_models) do
    [
      {
        name:      "Bing",
        languages: %w(ru en),
        translation_directions: [{ source: "ru", target: "en" }]
      }
    ]
  end

  before do
    stub_request(:get, path)
      .with(basic_auth: %w(foo bar))
      .to_return status:  200,
                 headers: { "Content-Type" => "application/json" },
                 body:    JSON(response_models)
  end

  subject { client.mt.engines }

  it "sends a request to ABBYY Cloud API" do
    subject
    expect(a_request(:get, path)).to have_been_made
  end

  it "returns list of engines" do
    expect(subject).to be_kind_of Array
    expect(subject.map(&:class)).to eq [ABBYY::Cloud::Models::Engine]
    expect(subject.map(&:to_h)).to  eq response_models
  end

  context "when API responded with error:" do
    before do
      stub_request(:get, path)
        .with(basic_auth: %w(foo bar))
        .to_return status:  500,
                   headers: { "Content-Type" => "application/json" },
                   body:    "Server error"
    end

    it "raises ResponseError" do
      expect { subject }.to raise_error(ABBYY::Cloud::ResponseError)
    end
  end

  context "when API returned invalid engine:" do
    let(:response_models) { [{ name: "Wrong" }] }

    it "raises TypeError" do
      expect { subject }.to raise_error(ABBYY::Cloud::TypeError)
    end
  end
end
