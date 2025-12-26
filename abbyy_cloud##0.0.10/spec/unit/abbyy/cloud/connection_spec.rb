RSpec.describe ABBYY::Cloud::Connection do
  let(:connection) { described_class.new id: "baz", token: "qux" }

  subject do
    connection.call :post,
                    "/foo/bar",
                    body:    { question: "The ultimate question" },
                    headers: { "X-Receiver": "Universe" }
  end

  let(:expected_request) do
    a_request(:post, "https://api.abbyy.cloud/foo/bar") do |req|
      expect(req.body).to eq(question: "The ultimate question")
      expect(req.headers).to include "Accept"         => "application/json",
                                     "Accept-Charset" => "utf-8",
                                     "Authorization"  => "Basic YmF6OnF1eA==",
                                     "Content-Type"   => "application/json",
                                     "Id"             => "baz",
                                     "Token"          => "qux",
                                     "X-Receiver"     => "Universe"
    end
  end

  context "when a server responded with success:" do
    before do
      stub_request(:post, "https://api.abbyy.cloud/foo/bar")
        .with(basic_auth: %w(baz qux))
        .to_return status:  200,
                   headers: { "Content-Type" => "application/json" },
                   body:    JSON(answer: 42)
    end

    it "sends the request" do
      subject
      expect(expected_request).to have_been_made
    end

    it "returns the response body" do
      expect(subject).to eq(JSON(answer: 42))
    end
  end

  context "when a server responded with error:" do
    before do
      stub_request(:post, "https://api.abbyy.cloud/foo/bar")
        .with(basic_auth: %w(baz qux))
        .to_return status:  400,
                   headers: { "Content-Type" => "application/json" },
                   body:    JSON(error: "Wrong question")
    end

    it "fails" do
      expect { subject }.to raise_error do |error|
        expect(error).to be_kind_of ABBYY::Cloud::ResponseError
        expect(error.status).to eq 400
        expect(error.data.to_h).to include(error: "Wrong question")
      end
    end
  end
end
