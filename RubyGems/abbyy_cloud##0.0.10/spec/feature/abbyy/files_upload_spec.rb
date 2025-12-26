RSpec.describe "files.upload" do
  subject do
    client.files.upload file,
                        synthesis_mode: synthesis_mode,
                        export_format:  export_format,
                        languages:      languages,
                        quality:        quality
  end

  let(:client)         { ABBYY::Cloud.new(id: "foo", token: "bar") }
  let(:path)           { %r{https://api.abbyy.cloud/v0/file} }
  let(:file)           { StringIO.new("Hello world!") }
  let(:export_format)  { "Doc" }
  let(:quality)        { "Fast" }
  let(:synthesis_mode) { "EditableCopy" }
  let(:languages)      { %w(en) }
  let(:response) do
    {
      id:    "foo",
      token: "bar",
      name:  "data.xml",
      mime:  "application/xml",
      is_recognizable: true,
      expected_languages: %w(en),
      ocr_settings: {
        format: "Doc",
        quality: "Fast",
        mode: "EditableCopy"
      },
      statistics: {
        language: "en",
        chars_count: 0,
        words_count: 0,
        pages_count: 0
      },
      ocr_statistics: {
        exported_pages: 0,
        total_characters: 0,
        uncertain_characters: 0,
        success_part: 0
      },
      created:   "2016-09-05T08:33:03.567Z",
      processed: "2016-09-05T08:33:03.567Z",
      deleted:   "2016-09-05T08:33:03.567Z",
      reading_progress: 0,
      reading_status: "New",
      ocr_warnings: [
        {
          warning_type: "BrightnessIsTooHigh",
          page_number: 0,
          dpi: 0,
          language_count: 0,
          full_warning_message: "Uwaga!"
        }
      ],
      error: "Unsupported",
      is_deleted: true
    }
  end

  before do
    stub_request(:post, path)
      .with(basic_auth: %w(foo bar))
      .to_return status:  200,
                 headers: { "Content-Type" => "application/json" },
                 body:    JSON([response])
  end

  context "with valid params" do
    it "sends a request to ABBYY Cloud API" do
      subject
      expect(a_request(:post, path)).to have_been_made
    end

    it "returns array of file info" do
      expect(subject.first).to be_kind_of ABBYY::Cloud::Models::FileInfo
    end
  end

  context "with wrong export_format:" do
    let(:export_format) { "Unknown" }

    it "raises ArgumentError without sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "with wrong quality:" do
    let(:quality) { "Unknown" }

    it "raises ArgumentError without sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "with wrong synthesis_mode:" do
    let(:synthesis_mode) { "Unknown" }

    it "raises ArgumentError without sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "with wrong languages:" do
    let(:languages) { "foo" }

    it "raises ArgumentError without sending a request" do
      expect { subject }.to raise_error(ABBYY::Cloud::ArgumentError)
      expect(a_request(:any, //)).not_to have_been_made
    end
  end

  context "when API responded with error:" do
    before do
      stub_request(:post, path)
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
