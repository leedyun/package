require 'spec_helper'

describe Blinkist::AirbrakeScrubber::MessageEmail do

  describe "Structure" do
    it "has REGEXP constant" do
      expect(described_class.constants).to include(:REGEXP)
    end

    it "has scrub! method" do
      expect(described_class).to respond_to(:scrub!)
    end
  end

  describe "self.scrub!" do
    subject { described_class::scrub! }

    it "adds the filter" do
      expect(Airbrake).to receive(:add_filter)
      subject
    end
  end

  # It's ridiculously hard to peek into Airbrake::Notice
  # Instead verify the functionality here
  describe ".scrub" do
    let(:filtered)  { Blinkist::AirbrakeScrubber::FILTERED }
    let(:regexp)    { described_class::REGEXP }

    let(:valid_domains) { %w{ example.org exam-ple.org exam.ple.org e-xam.ple.org e-xam.p-le.org e.x.a.m.p.l.e.co.uk } }
    let(:valid_usernames) { %w{ username user.name user+name user-name user_name } }
    let(:valid_emails) { valid_usernames.product(valid_domains).map { |row| row.join '@' } }
    let(:invalid_emails) { %w{ user@example user@example. user!@example.org us@r@example.org us&r@example.com } }

    context "Pure email content" do
      it "filters out valid emails" do
        puts "Verifying: #{ valid_emails.join ', ' }"
        valid_emails.each do |email|
          expect(described_class.scrub(email)).to eq(filtered)
        end
      end

      it "filters out invalid emails" do
        puts "Verifying: #{ invalid_emails.join ', ' }"
        invalid_emails.each do |email|
          expect(described_class.scrub(email)).to eq(filtered)
        end
      end
    end

    context "Email inside a text" do
      let(:text) { "Erorr bla bla EMAIL bla bla bla" }

      it "filters out valid emails" do
        puts "Verifying: #{ valid_emails.join ', ' }"
        valid_emails.each do |email|
          content = text.gsub('EMAIL', email)
          expect(described_class.scrub(content)).to eq(text.gsub('EMAIL', filtered))
        end
      end

      it "filters out invalid emails" do
        puts "Verifying: #{ invalid_emails.join ', ' }"
        invalid_emails.each do |email|
          content = text.gsub('EMAIL', email)
          expect(described_class.scrub(content)).to eq(text.gsub('EMAIL', filtered))
        end
      end
    end

    context "Anything that is a frozen string" do
      subject { described_class.scrub text }
      let(:text) { "Error bla bla bla test@example.org bla bla bla".freeze }

      it "filters out email" do
        expect(subject).to eq(text.gsub('test@example.org', filtered))
      end
    end
  end

end
