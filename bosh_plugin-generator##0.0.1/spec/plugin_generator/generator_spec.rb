describe Bosh::PluginGenerator::Generator do
  let(:context) { { people: ['you', 'me'] } }
  let(:tmpdir) { Dir.mktmpdir }
  let(:target) { File.join(tmpdir, 'subfolder-1', 'subfolder-2', 'result.txt') }
  subject { Bosh::PluginGenerator::Generator.new(context, source_folder: File.expand_path('../../assets', __FILE__)) }
  after { FileUtils.remove_entry_secure tmpdir }

  describe '#generate' do
    before do
      subject.generate('simple-template.txt', target)
    end

    context 'simple template' do 

      it 'creates file with folder' do
        expect(File).to exist(target)
      end
      
      it 'creates renders ERB' do
        expect(File.read(target)).to match(/you, me/)
      end
      
    end
  end
end