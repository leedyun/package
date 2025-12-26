require 'spec_helper'

describe RoyalMailScraper::Tracker do
  describe '.fetch' do
    subject(:tracker) { described_class.fetch(tracking_number) }

    shared_examples 'tracker with details' do
      it 'contains correct detail statuses' do
        expect(tracker).to be_instance_of(described_class)
        expect(tracker.tracking_number).to eq tracking_number
        expect(tracker.details.map(&:status)).to eq expected_statuses
        expect(tracker.status).to eq expected_statuses.last
        expect(tracker.datetime).to eq tracker.details.last.datetime if tracker.details.any?
        expect(tracker.message).to eq tracker.details.last.message if tracker.details.any?
        expect(tracker.location).to eq tracker.details.last.location if tracker.details.any?
        expect(tracker.recognised_details).not_to be_empty if tracker.details.any?
      end
    end

    context 'with real response' do
      let(:tracking_number) { 'RU401513974GB' }
      let(:expected_statuses) do
        ["in_transit", "in_transit", "in_transit", "delivered"]
      end

      it_behaves_like 'tracker with details'
    end

    context 'with mocked response' do
      let(:tracking_number) { 'KF000000000GB' }
      let(:html) { File.binread(File.dirname(__FILE__) + '/assets/' + file) }
      let(:page) { Mechanize::Page.new(URI('http://test'), nil, html) }

      before do
        expect_any_instance_of(RoyalMailScraper::Tracker::Request).to(
          receive(:fetch_details_page).and_return(page)
        )
      end

      context 'collected' do
        let(:file) { 'collected.html' }

        let(:expected_statuses) do
          ["in_transit", "undelivered", "held_at_enquiry_office", "in_transit"]
        end

        it_behaves_like 'tracker with details'

        its('datetime.to_s') { should eq '2014-07-02T13:28:00+00:00' }
      end

      context 'delivered' do
        let(:file) { 'delivered.html' }

        let(:expected_statuses) do
          ["in_transit", "in_transit", "in_transit", "in_transit", "in_transit", "in_transit",
           "on_delivery", "delivered", "delivered"]
        end

        it_behaves_like 'tracker with details'
      end

      context 'on delivery' do
        let(:file) { 'on_delivery.html' }

        let(:expected_statuses) do
          ["in_transit", "undelivered", "held_at_enquiry_office", "on_delivery"]
        end

        it_behaves_like 'tracker with details'
        end

      context 'not found' do
        let(:file) { 'not_found.html' }

        let(:expected_statuses) do
          []
        end

        it_behaves_like 'tracker with details'
      end
    end
  end
end
