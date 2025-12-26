RSpec.describe ABBYY::Cloud::Models::Locale do
  it "accepts simple language locales" do
    %w(en sjp yds).each do |locale|
      expect(described_class[locale]).to eq locale
    end
  end

  it "accepts scripted locales" do
    %w(ar-Aran).each do |locale|
      expect(described_class[locale]).to eq locale
    end
  end

  it "accepts regional locales" do
    %w(en-GB igb-AA en-018).each do |locale|
      expect(described_class[locale]).to eq locale
    end
  end

  it "accepts scripted regional locales" do
    %w(ar-Aran-YE ar-Aran-002).each do |locale|
      expect(described_class[locale]).to eq locale
    end
  end

  it "accepts scripted regional subtagged locales" do
    %w(fr-Aran-FR-1606nict de-1996 de-DE-1996).each do |locale|
      expect(described_class[locale]).to eq locale
    end
  end

  it "accepts grandfarthered locales" do
    %w(cel-gaulish i-ami en-GB-oed sgn-BE-NL).each do |locale|
      expect(described_class[locale]).to eq locale
    end
  end

  it "accepts redundant locales" do
    %w(bs-Latn de-AT-1901 zh-Hans-TW).each do |locale|
      expect(described_class[locale]).to eq locale
    end
  end

  it "accepts private-use locales" do
    %w(en-x-it).each do |locale|
      expect(described_class[locale]).to eq locale
    end
  end

  it "declines locales that mismatch IANA/IETF standards" do
    %w(i en_EN).each do |locale|
      expect { described_class[locale] }.to raise_error(StandardError)
    end
  end
end
