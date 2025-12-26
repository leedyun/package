module Cnvrg
  class Storage
    def initialize(dataset: nil, project: nil, root_path: nil)
      @element = dataset || project
      @root_path = root_path
      @client = @element.get_storage_client
    end

    def log_error(action: nil, error: '')
      "[#{Time.now}] (#{action || 'default'}) #{error}"
    end


    def get_chunks_size
      (ENV['CNVRG_STORAGE_CHUNK_SIZE'] || 10).to_i
    end

    def init_progress_bar(size: nil, title: "Download Progress")
      @progressbar = ProgressBar.create(:title => title,
                                       :progress_mark => '=',
                                       :format => "%b>>%i| %p%% %t",
                                       :starting_at => 0,
                                       :total => size,
                                       :autofinish => true)
    end

    def make_progress(size: 1)
      @progressbar.progress += size
    end


    def clone(commit: nil)
      files_generator = Proc.new do |params|
        @element.get_clone_chunk(commit: commit, chunk_size: params[:limit], offset: params[:offset])
      end
      action = Proc.new do |storage, local|
        @client.safe_download(storage, local)
      end

      @stats = @element.get_stats
      progress = {size: @stats['commit_size'], title: "Clone Progress"}

      storage_action(files_generator: files_generator, action: action, progress: progress)
    end

    def upload_files(commit: nil)

    end

    def upload_files(files_generator, progress: {size: 0, title: ''})
      init_progress_bar(progress)
      @storage_errors = []
      @finished = false
      @files = Queue.new
      t = Thread.new{file_gen_thread(files_generator)}
      do_parallel{|file| self.upload_files_thread(file); self.make_progress(size: file['size'])}
      t.join
      handle_errors
    end

    def file_gen_upload_thread(files_generator)
      while true
        files = files_generator
        files.each{|f| @files.push(f)}
        break if files.blank?
      end
      @finished = true
    end

    def storage_action(files_generator: nil, action: nil, progress: {size: 0, title: ''})
      ### the generator files should have {path (encrypted), name, size}
      init_progress_bar(progress)
      @storage_errors = []
      @finished = false
      @files = Queue.new
      t = Thread.new{file_gen_thread(files_generator)}
      do_parallel do |file|
        self.download_file_thread(file) do |local, storage|
          action.call(local, storage)
        end
        self.make_progress(size: file['size'])
      end
      t.join
      handle_errors
    end

    def file_gen_thread(file_gen)
      offset = 0
      chunk_size = get_chunks_size
      while true
        files = file_gen.call(limit: chunk_size, offset: offset)
        break if files.blank?
        files.each{|f| @files.push(f)}
        offset += files.size
      end
      @finished = true
    end

    def handle_errors
      if @storage_errors.present?
        File.open(@element.working_dir + "/.cnvrg/errors.yml", "w+"){|f| f.write @storage_errors.to_yaml}
      end
    end

    def do_parallel
      Parallel.each( -> { @files.empty? ? (@finished ? Parallel::Stop : sleep(1)) : @files.pop }, in_threads: get_chunks_size) do |file|
        if file == 1
          next
        end
        yield(file)
      end
    end

    def download_file_thread(file)
      return if file.blank?
      local_path = file['name']
      storage_path = file['path']
      (0..5).each do
        begin
        # @client.download(storage_path, "#{@root_path}/#{local_path}")
        break
        rescue => e
          log_error(action: "download #{local_path}", error: e.message)
        end
      end
    end
  end
end