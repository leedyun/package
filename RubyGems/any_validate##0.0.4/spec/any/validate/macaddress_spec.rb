describe Any::Validate::Macaddress do

  describe '#valid_macaddress?' do
    context 'when macaddress is B4:B5:2F:63:0F:7C' do
      it 'return true' do
        expect( valid_macaddress? mac: 'B4:B5:2F:63:0F:7C' ).to be(true)
      end
    end
    context 'when macaddress is b4:b5:2f:63:0f:7c' do
      it 'return true' do
        expect( valid_macaddress? mac: 'b4:b5:2f:63:0f:7c' ).to be(true)
      end
    end
    context 'when macaddress is B4:B5:2F:63:0F:7G' do
      it 'return false' do
        expect( valid_macaddress? mac: 'B4:B5:2F:63:0F:7G' ).to be(false)
      end
    end
    context 'when macaddress is B4:B5:2F:63:0F:7CA' do
      it 'return false' do
        expect( valid_macaddress? mac: 'B4:B5:2F:63:0F:7CA' ).to be(false)
      end
    end
  end

end
