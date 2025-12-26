describe Any::Validate::Uuid do

  describe '#valid_uuid?' do
    context 'when uuid is FEAAF64D-6132-44DD-8779-C2E297B6225B' do
      it 'return true' do
        expect( valid_uuid? uuid: 'FEAAF64D-6132-44DD-8779-C2E297B6225B' ).to be(true)
      end
    end
    context 'when uuid is FEAAF64D-6132-44DD-8779-C2E297B6225G' do
      it 'return false' do
        expect( valid_uuid? uuid: 'FEAAF64D-6132-44DD-8779-C2E297B6225G' ).to be(false)
      end
    end
    context 'when uuid is FEAAF64D-6132-44DD-8779-C2E297B6225B1' do
      it 'return false' do
        expect( valid_uuid? uuid: 'FEAAF64D-6132-44DD-8779-C2E297B6225B1' ).to be(false)
      end
    end
  end

end
