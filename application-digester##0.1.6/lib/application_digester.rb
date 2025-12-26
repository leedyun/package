class ApplicationDigester
  # Taking into account the location of every file helps capture changes such as
  # a file moving location, but the contents remain unchanged.
  def digest
    Digest::SHA256.hexdigest(file_digests.join + relative_paths.join)
  end

  private

  def relative_paths
    paths.map do |path|
      if path.start_with?(absolute_path_prefix)
        path.split(absolute_path_prefix, 2).last
      else
        fail "Expected string to start with #{absolute_path_prefix}"
      end
    end
  end

  def absolute_path_prefix
    Rails.root.to_path + '/' # Not sure if we need to add this.
  end

  def file_digests
    files.map { |path| Digest::SHA256.hexdigest(File.read(path)) }
  end

  def files
    paths.select { |path| File.file?(path) }
  end

  def paths
    all_paths - exclude_paths
  end

  def all_paths
    Dir[Rails.root.join('./**/*')].sort
  end

  def exclude_paths
    Dir[*EXCLUDE_DIRS.map do |dir_name|
      [
        Rails.root.join("#{dir_name}/**/*"),
        Rails.root.join(dir_name), # This removes the excluded dir itself
      ]
    end.flatten]
  end

  EXCLUDE_DIRS = %w(log tmp public/assets vendor/bundle).freeze
end
