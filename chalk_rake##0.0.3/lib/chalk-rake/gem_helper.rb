class Chalk::Rake::GemHelper
  include Rake::DSL if defined? Rake::DSL

  def self.install_tasks
    self.new.install
  end

  def install
    task :bump do |i|
      glob = File.join(Dir.pwd, 'lib/*/version.rb')
      version_files = Dir[glob]
      if version_files.length == 0
        raise "No version file found"
      elsif version_files.length > 1
        raise "Found #{version_files.length} version files: #{version_files.inspect}"
      end
      version_file = version_files.first
      contents = File.read(version_file)
      new = nil
      contents = contents.gsub(/(VERSION = [\'\"])(\d+\.\d+\.)(\d+)/) do
        bumped = $3.to_i + 1
        new = $2 + bumped.to_s
        $1 + new
      end
      if defined?(Bundler)
        Bundler.ui.confirm("Bumping to #{new}")
      else
        puts "Bumping to #{new}"
      end
      File.open(version_file, 'w') {|f| f.write(contents)}
      sh 'git', 'add', version_file
      sh 'git', 'commit', '-m', 'Bump version'
      # Would be nicer to just Rake::Task[:release].invoke, but we'd
      # have to redefine the VERSION constant.
      sh 'bundle', 'exec', 'rake', 'release'
    end
  end
end
