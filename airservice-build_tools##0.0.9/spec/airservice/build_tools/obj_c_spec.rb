require 'spec_helper'
require 'airservice/build_tools/obj_c'

describe AirService::BuildTools::ObjC do
  include described_class
  describe '#update_plist_version' do
    include FakeFS::SpecHelpers
    it 'raises error when file_path is not specified' do
      expect{update_plist_version}.to raise_error do |error|
        expect(error.message).to include('file path')
      end
    end
    it 'raises error when file_path does not exists' do
      expect{update_plist_version(file_path: 'some file path')}.to raise_error  do |error|
        expect(error.message).to include('exists')
      end
    end
    context 'when updating without errors' do
      let(:plist_file) {
        <<-plist
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleDevelopmentRegion</key>
        <string>en</string>
      </dict>
      </plist>
        plist
      }

      it 'adds version and build number in plist' do
        file_path = 'test_plist.plist'
        File.open(file_path, 'w+') { |f| f.write(plist_file) }

        update_plist_version(file_path: file_path, build_version: '345', version: '1.1.345')

        actual = Plist::parse_xml(file_path)
        actual['CFBundleVersion'].should eq('345')
        actual['CFBundleShortVersionString'].should eq('1.1.345')
      end
      it 'ignores not specified version' do
        file_path = 'test_plist.plist'
        File.open(file_path, 'w+') { |f| f.write(plist_file) }

        update_plist_version(file_path: file_path)

        actual = File.read(file_path)
        actual.should_not include('CFBundleVersion')
        actual.should_not include('CFBundleShortVersionString')
      end
      it 'forces the bundle version to be a string' do
        file_path = 'test_plist.plist'
        File.open(file_path, 'w+') { |f| f.write(plist_file) }

        update_plist_version(file_path: file_path, build_version: 345, version: 345)

        actual = Plist::parse_xml(file_path)
        actual['CFBundleVersion'].should eq('345')
        actual['CFBundleShortVersionString'].should eq('345')
      end
    end
  end

  describe '#create_ios_icons' do
    before do
      FileUtils.rmtree('/tmp/icons/ios')
    end
    it 'throws exception if it source file is not found' do
      expect { create_ios_icons(source: 'spec/fixtures/does_not_exist.png', output_dir: '/tmp/icons/ios') }.to raise_error do |error|
        expect(error.message).to include('source file')
      end
    end
    it 'creates images of non retina sizes' do
      create_ios_icons(source: 'spec/fixtures/test_image.png', output_dir: '/tmp/icons/ios')
      icons = Dir['/tmp/icons/ios/*.png'].map do |file|
        `identify #{file}`
      end.join(' ')
      icons.should include('76x76', '40x40', '29x29')
    end
    it 'creates images of retina sizes when specified' do
      create_ios_icons(source: 'spec/fixtures/test_image.png', output_dir: '/tmp/icons/ios/')
      icons = Dir['/tmp/icons/ios/*.png'].map do |file|
        `identify #{file}`
      end.join(' ')
      icons.should include('152x152', '80x80', '58x58')
    end
    it 'creates images with correct names for ipad' do
      create_ios_icons(source: 'spec/fixtures/test_image.png', output_dir: '/tmp/icons/ios/')
      icons = Dir['/tmp/icons/ios/*.png'].join(' ')
      icons.should include('ipad@2x.png', 'ipad@1x.png')
    end
  end
end
