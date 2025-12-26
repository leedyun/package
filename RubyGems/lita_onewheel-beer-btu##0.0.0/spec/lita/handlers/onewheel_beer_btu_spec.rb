require_relative '../../spec_helper'

describe Lita::Handlers::OnewheelBeerBtu, lita_handler: true do
  it { is_expected.to route_command('btu') }
  it { is_expected.to route_command('btu 4') }
  it { is_expected.to route_command('btu <$4') }
  it { is_expected.to route_command('btu <=$4') }
  it { is_expected.to route_command('btu >4%') }
  it { is_expected.to route_command('btu >=4%') }
  it { is_expected.to route_command('btuabvhigh') }
  it { is_expected.to route_command('btuabvlow') }

  before do
    mock = File.open('spec/fixtures/btu.txt').read
    allow(Lita::Handlers::OnewheelBeerBtu).to receive(:pull_pdf) { mock }
  end

  it 'shows the taps' do
    send_command 'btu'
    expect(replies.last).to include("BTU taps: 1) BRUMATOR - 8.7%  2) HORNED HAND - 9.5%  3) JADE TIGER IPA - 6.8%  4) BTU LAGER - 5.8%  5) GHOSTMAN WHITE LAGER - 5.4%  6) BUTTAH-NUT GOSE - 4.9%  7) WET TIGER IPA - 6.8%  8) IMPERIAL RED - 8.3%")
  end

  it 'displays details for tap jade' do
    send_command 'btu jade'
    expect(replies.last).to eq("BTU's tap 7) WET TIGER IPA - 6.8% ABV ?? IBU - Our standard Jade Tiger IPA recipe made with fresh mosaic hops. It’s the most wonderful time of the year!")
  end

  it 'displays details for tap 7' do
    send_command 'btu 7'
    expect(replies.last).to include("BTU's tap 7) WET TIGER IPA - 6.8% ABV ?? IBU - Our standard Jade Tiger IPA recipe made with fresh mosaic hops. It’s the most wonderful time of the year!")
  end

  it 'displays details for tap 5' do
    send_command 'btu 5'
    expect(replies.last).to include("BTU's tap 5) GHOSTMAN WHITE LAGER - 5.4% ABV 16 IBU - An unﬁltered wheat lager using oats to create a creamy head. Coriander and orange peel give this lager its ﬂoral aroma.")
  end
end
