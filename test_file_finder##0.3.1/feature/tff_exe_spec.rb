# frozen_string_literal: true

RSpec.describe 'tff exe' do
  subject(:output) { `ruby -Ilib ../exe/tff #{options} #{files}` }

  around do |example|
    Dir.chdir(File.join(__dir__, '../fixtures')) do
      example.run
    end
  end

  context 'without any mapping' do
    let(:options) { nil }
    let(:files) { 'app/models/test_file_finder_gem_executable_widget.rb' }

    it 'prints matching test files using default rails mapping' do
      expect(output).to eq <<~OUTPUT
        spec/models/test_file_finder_gem_executable_widget_spec.rb
      OUTPUT
    end
  end

  context 'with a yaml mapping' do
    let(:options) { '-f mapping.yml' }

    context 'with multiple sources' do
      ['db/schema.rb', 'db/migrate/001_init.rb'].each do |file|
        context "with file #{file}" do
          let(:files) { file }

          it 'prints matching test files using given yaml mapping' do
            expect(output).to eq <<~OUTPUT
              spec/db/schema_spec.rb
            OUTPUT
          end
        end
      end
    end

    context 'with multiple tests' do
      let(:files) { 'spec/models/project_spec.rb' }

      it 'prints matching test files using given yaml mapping' do
        expect(output).to eq <<~OUTPUT
          spec/models/project_spec.rb
          spec/smoke_spec.rb
        OUTPUT
      end
    end

    context 'with multiple sources and tests' do
      ['views/main.html.haml', 'assets/application.css'].each do |file|
        context "with file #{file}" do
          let(:files) { file }

          it 'prints matching test files using given yaml mapping' do
            expect(output).to eq <<~OUTPUT
              spec/views/main_spec.rb
              features/smoke.feature
            OUTPUT
          end
        end
      end
    end

    context 'with named captures' do
      let(:files) { 'lib/api/issues.rb' }

      it 'prints matching test files using given yaml mapping' do
        expect(output).to eq <<~OUTPUT
          spec/requests/api/issues/issues_spec.rb
        OUTPUT
      end
    end
  end

  context 'with a yaml mapping and json mapping' do
    let(:options) { '-f mapping.yml --json mapping.json' }
    let(:files) { 'db/schema.rb app/models/project.rb ' }

    it 'prints matching test files using both yaml and json mappings' do
      expect(output).to eq <<~OUTPUT
        spec/models/project_spec.rb
        spec/controllers/projects_controller_spec.rb
        spec/db/schema_spec.rb
      OUTPUT
    end
  end

  context 'with only json mapping' do
    let(:options) { '--json mapping.json' }
    let(:files) { 'app/models/test_file_finder_gem_executable_widget.rb app/models/project.rb' }

    it 'prints matching test files using json mapping' do
      expect(output).to eq <<~OUTPUT
        spec/models/project_spec.rb
        spec/controllers/projects_controller_spec.rb
      OUTPUT
    end
  end
end
