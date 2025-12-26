require 'helper'

describe AbnValidator do

  subject { TestBusiness.new }

  it 'should be ok with nil ABNs' do
    expect(subject.valid?).to be(true)
  end

  it 'should invalidate invalid ABNs' do
    INVALID_ABNS.each do |abn|
      subject.abn = abn
      expect(subject.valid?).to be(false)
    end
  end

  it 'should be ok with valid ABNs' do
    VALID_ABNS.each do |abn|
      subject.abn = abn
      expect(subject.valid?).to be(true)
    end
  end

end
