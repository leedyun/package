require 'spec_helper'
require 'airservice/build_tools/android'

describe AirService::BuildTools::Android do
  include described_class

  describe '#create_android_icons' do
    before do
      FileUtils.rmtree('/tmp/icons/android')
    end
    it 'throws exception if it source file is not found' do
      expect { create_android_icons(source: 'spec/fixtures/does_not_exist.png', output_dir: '/tmp/icons/android') }.to raise_error do |error|
        expect(error.message).to include('source file')
      end
    end
    it 'creates images of desired sizes' do
      create_android_icons(source: 'spec/fixtures/test_image.png', output_dir: '/tmp/icons/android')
      icons = Dir['/tmp/icons/android/**/*.png'].map do |file|
        `identify #{file}`
      end.join(' ')
      icons.should include('36x36', '48x48', '72x72', '96x96')
    end
    it 'creates images with correct names' do
      create_android_icons(source: 'spec/fixtures/test_image.png', output_dir: '/tmp/icons/android')
      icons = Dir['/tmp/icons/android/**/*.png'].join(' ')
      icons.should include('icon.png')
    end
    it 'creates the correct folder names' do
      create_android_icons(source: 'spec/fixtures/test_image.png', output_dir: '/tmp/icons/android')
      folder = Dir['/tmp/icons/android/*'].join(' ')
      folder.should include('drawable', 'drawable-ldpi', 'drawable-mdpi', 'drawable-hdpi', 'drawable-xhdpi')
    end
  end
end
