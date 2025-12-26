describe 'bosh generate plugin' do

  describe 'magic command' do

    before(:context) do
      @current_dir = Dir.pwd
      @tmpdir = Dir.mktmpdir
      Dir.chdir(@tmpdir)
    end

    after(:context) do
      Dir.chdir(@current_dir)
      FileUtils.remove_entry_secure(@tmpdir)
    end

    context 'without parameters and "bosh-" preffix' do
      let(:plugin_folder) { File.join(Dir.pwd, 'magic') }

      before(:all) do
        system('bosh generate plugin magic > /dev/null')
      end

      it 'creates gem with "bosh-" prefix' do
        gemspec_file = File.join(plugin_folder, 'bosh-magic.gemspec')
        expect(File).to exist(gemspec_file)
        expect(File.read(gemspec_file)).to match(/bosh-magic/)
      end

      it 'generates gemspec with email from Git setup' do
        expect(File.read("#{plugin_folder}/bosh-magic.gemspec")).to include(Git.global_config["user.name"])
        expect(File.read("#{plugin_folder}/bosh-magic.gemspec")).to include(Git.global_config["user.email"])
      end

      it 'has no license file' do
        expect(File).not_to exist(File.join(plugin_folder, 'LICENSE'))
      end

      it 'has initialized git repository' do
        expect(File).to exist(File.join(plugin_folder, '.git'))
      end

      it 'can run rspec on generated plugin (using rake command)' do
        Dir.chdir(plugin_folder) do
          Bundler.with_clean_env do
            system('bundle exec rake')
          end
        end
        expect($?.exitstatus).to eq(0)
      end

    end

    context 'with parameters, license and "bosh-" prefix' do
      let(:plugin_folder) { File.join(Dir.pwd, 'bosh-magic') }

      before(:all) do
        command = <<-CMD 
                         bosh generate plugin bosh-magic --email=gandalf@email.com \
                                                         --author=Gandalf          \
                                                         --license=mit > /dev/null
CMD
        system(command)
      end

      it 'creates folder with the name specified as plugin a name' do
        expect(File).to exist(plugin_folder)
      end

      it 'creates gem with "bosh-" prefix' do
        gemspec_file = File.join(plugin_folder, 'bosh-magic.gemspec')
        expect(File).to exist(gemspec_file)
        expect(File.read(gemspec_file)).to match(/bosh-magic/)
      end

      it 'generates gemspec with correct email' do
        expect(File.read("#{plugin_folder}/bosh-magic.gemspec")).to match(/gandalf@email.com/)
      end

      it 'creates license file' do
        expect(File).to exist(File.join(plugin_folder, 'LICENSE'))
      end

    end    
  end
end
