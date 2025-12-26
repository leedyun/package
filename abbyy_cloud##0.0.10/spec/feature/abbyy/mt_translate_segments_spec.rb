RSpec.describe "mt.translate_segments" do
  let(:client)          { ABBYY::Cloud.new settings }
  let(:settings)        { { id: "foo", token: "bar", engine: default_engine } }
  let(:default_engine)  { "Google" }
  let(:custom_engine)   { "Bing" }
  let(:source_language) { "ru" }
  let(:target_language) { "en" }
  let(:source_text)     { "Бить или не бить" }
  let(:path)            { "https://api.abbyy.cloud/v1/order/mt/sync" }
  let(:response_status) { 200 }
  let(:response_model)  { { id: "42", text: "To beat or not to beat" } }
  let(:params) do
    { from: source_language, to: target_language, engine: custom_engine }
  end

  before do
    stub_request(:post, path)
      .with(basic_auth: %w(foo bar))
      .to_return status:  response_status,
                 headers: { "Content-Type" => "application/json" },
                 body:    JSON([response_model])
  end

  subject { client.mt.translate_segments [source_text], params }

  it "sends a request to ABBYY Cloud API" do
    subject
    expect(a_request(:post, path)).to have_been_made
  end

  it "returns translation model" do
    item = subject.first
    expect(item).to be_kind_of ABBYY::Cloud::Models::TranslationSegment
    expect(item.to_h).to include response_model
  end

  context "without custom engine:" do
    before { params.delete :engine }

    let(:expected_request) do
      a_request(:post, path).with do |req|
        expect(JSON.parse(req.body)).to include "engine" => "Google"
      end
    end

    it "uses default engine in the request" do
      subject
      expect(expected_request).to have_been_made
    end
  end

  context "when no engine is set:" do
    before { settings.delete :engine }
    before { params.delete :engine }

    let(:expected_request) do
      a_request(:post, path).with do |req|
        expect(JSON.parse(req.body)).to include "engine" => "Sandbox"
      end
    end

    it "uses Sandbox engine in the request" do
      subject
      expect(expected_request).to have_been_made
    end
  end

  context "without text to translate:" do
    let(:source_text) { nil }

    it "raises ArgumentError before sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "with invalid source language:" do
    let(:source_language) { "1" }

    it "raises ArgumentError before sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "without source language:" do
    before { params.delete :from }

    it "raises ArgumentError before sending a request" do
      expect { subject }.to raise_error(::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "with invalid target language:" do
    let(:target_language) { "1" }

    it "raises ArgumentError before sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "without target language:" do
    before { params.delete :to }

    it "raises ArgumentError before sending a request" do
      expect { subject }.to raise_error(::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "when API responded with error:" do
    before { stub_request(:post, path).to_return status: 500 }

    it "raises ResponseError" do
      expect { subject }.to raise_error(ABBYY::Cloud::ResponseError)
    end
  end

  context "when API returned data without an id:" do
    let(:response_model) { { translation: "To beat or not to beat" } }

    it "raises TypeError" do
      expect { subject }.to raise_error(ABBYY::Cloud::TypeError)
    end
  end

  context "when API returned data without a translation:" do
    let(:response_model) { { id: 1 } }

    it "raises TypeError" do
      expect { subject }.to raise_error(ABBYY::Cloud::TypeError)
    end
  end
end
