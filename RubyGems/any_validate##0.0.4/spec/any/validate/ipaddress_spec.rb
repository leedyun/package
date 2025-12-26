describe Any::Validate::Ipaddress do

  describe '#valid_ipaddress?' do
    context 'when ipaddress is 127.0.0.1' do
      it 'return true' do
        expect( valid_ipaddress? ip: '127.0.0.1' ).to be(true)
      end
    end
    context 'when ipaddress is 255.255.255.255' do
      it 'return true' do
        expect( valid_ipaddress? ip: '255.255.255.255' ).to be(true)
      end
    end
    context 'when ipaddress is 0.0.0.0' do
      it 'return true' do
        expect( valid_ipaddress? ip: '0.0.0.0' ).to be(true)
      end
    end
    context 'when ipaddress is 256.256.256.256' do
      it 'return false' do
        expect( valid_ipaddress? ip: '256.256.256.256' ).to be(false)
      end
    end
    context 'when ipaddress is 255.255.255.2555' do
      it 'return false' do
        expect( valid_ipaddress? ip: '255.255.255.2555' ).to be(false)
      end
    end
    context 'when ipaddress is 0.0.0.00' do
      it 'return false' do
        expect( valid_ipaddress? ip: '0.0.0.00' ).to be(false)
      end
    end
  end

end
