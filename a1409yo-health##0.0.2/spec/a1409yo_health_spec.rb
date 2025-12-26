require 'spec_helper'

describe A1409yoHealth do
  it 'has a version number' do
    expect(A1409yoHealth::VERSION).not_to be nil
  end

  it 'weight = 50' do
    expect(A1409yoHealth::WEIGHT).to eq(50)
  end

  it 'bmi calc' do
    expect(A1409yoHealth::BMI.exec(50,1.5)).to be > 10.0
  end
end
