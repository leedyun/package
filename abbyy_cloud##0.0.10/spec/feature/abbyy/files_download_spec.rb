RSpec.describe "files.download" do
  subject { client.files.download(options) }

  let(:client)  { ABBYY::Cloud.new(id: "foo", token: "bar") }
  let(:path)    { "https://api.abbyy.cloud/v0/file/baz/qux" }
  let(:options) { { id: "baz", token: "qux" } }

  before do
    stub_request(:get, path)
      .with(basic_auth: %w(foo bar))
      .to_return(status: 200, body: "Hello world!")
  end

  context "with valid params" do
    it "sends a request to ABBYY Cloud API" do
      subject
      expect(a_request(:get, path)).to have_been_made
    end

    it "returns an IO" do
      expect(subject).to be_kind_of StringIO
      expect(subject.read).to eq "Hello world!"
    end
  end

  context "without id:" do
    before { options.delete(:id) }

    it "raises ArgumentError without sending a request" do
      expect { subject }.to raise_error(ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "without token:" do
    before { options.delete(:token) }

    it "raises ArgumentError without sending a request" do
      expect { subject }.to raise_error(ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
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
end
