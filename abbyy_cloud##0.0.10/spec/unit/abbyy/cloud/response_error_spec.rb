RSpec.describe ABBYY::Cloud::ResponseError do
  let(:body) { JSON(data) }
  let(:data) do
    {
      request_id: "foobar",
      error: "Unprocessable entity",
      error_description: "Wrong language",
      model_state: { "id" => 0, "language" => "en_FR" }
    }
  end

  let(:response) do
    instance_double "Net::HTTPResponse", code: "400", body: body
  end

  subject { described_class.new response }

  it { is_expected.to be_kind_of StandardError }
  its(:status)     { is_expected.to eq 400 }
  its("data.to_h") { is_expected.to eq data }

  context "when server returned non-json body:" do
    let(:body) { "Something went wrong" }

    its("data.error") { is_expected.to eq "Server error" }
    its("data.error_description") { is_expected.to eq "Something went wrong" }
  end
end
