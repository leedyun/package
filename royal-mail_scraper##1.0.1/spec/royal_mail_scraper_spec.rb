require 'spec_helper'

describe RoyalMailScraper do
  describe '.tracking_number?' do
    let(:examples) do
      {
        'RU401513974GB' => true,
        'ru401513974gb' => true,
        'RU401513974CZ' => false,
        'RU4015139GB' => false,
      }
    end

    specify do
      examples.each do |tracking_number, expected_result|
        expect(RoyalMailScraper.tracking_number?(tracking_number)).to be(expected_result)
      end
    end
  end
end
