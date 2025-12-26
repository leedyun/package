describe Any::Validate do
  describe 'VERSION' do

    it 'should be 0.0.4' do
      expect( Any::Validate::VERSION ).to eql('0.0.4')
    end
    it 'should be a String' do
      expect( Any::Validate::VERSION ).to be_a(String)
    end

  end
end
