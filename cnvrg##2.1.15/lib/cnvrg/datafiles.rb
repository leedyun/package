require 'mimemagic'
require 'aws-sdk-s3'
require 'URLcrypt'
require 'parallel'
require 'fileutils'


module Cnvrg
  class Datafiles
    ParallelThreads ||= Cnvrg::Helpers.parallel_threads
    DIRECTORY_REGEX = /^[a-zA-Z0-9_\/-]+$/
    LARGE_FILE=1024*1024*5
    MULTIPART_SPLIT=10000000
    RETRIES = ENV['UPLOAD_FILE_RETRIES'].try(:to_i) || 10

    attr_reader :base_resource

    def initialize(owner, dataset_slug, dataset: nil)
      @dataset_slug = dataset_slug
      @owner = owner
      @dataset = dataset
      @base_resource = "users/#{owner}/datasets/#{dataset_slug}/"
      @downloader = @dataset.get_storage_client
      @token_issue_time = Time.current
    end

    def refresh_storage_token
      current_time = Time.current
      if current_time - @token_issue_time > 1.hours
        @downloader = @dataset.get_storage_client
        @token_issue_time = Time.current
      end
    end

    def check_file_sha1(filename, org_sha1, tag: 'conflict')
      file_loc = "#{Dir.pwd}/#{filename}"
      sha1 =  OpenSSL::Digest::SHA1.file(file_loc).hexdigest
      return 0 if sha1 == org_sha1
      FileUtils.cp(file_loc, "#{file_loc}.#{tag}")
      return 1
    end

    def verify_files_exists(files)
      paths = []
      files.each do |file|
        # dir shouldnt have ending slash.
        file = file[0..-2] if file.end_with? '/'
        if File.exists? file
          if File.directory? file
            paths << file unless file == '.'
            paths += Dir.glob("#{file}/**/*")
          else
            paths << file
          end
          next
        end
        raise SignalException.new(1, "Cant find file #{file}") unless File.exists? "#{Dir.pwd}/#{file}"
      end
      is_valid_directory?(paths)
      paths
    end

    def is_valid_directory?(paths)
      paths.each do |path|
        path = path.gsub('./', '')
        if !path.match(DIRECTORY_REGEX) and File.directory? path
          raise SignalException.new(1, "#{path} is invalid directory name, should contain letters, numbers, '_' , '-'")
        end
      end
    end

    def get_files_and_folders(paths)
      files_and_folders = {}
      paths.each do |file|
        if File.exists? file
          if File.directory? file
            Dir.glob("#{file}/**/*").select do |f|
              files_and_folders["#{f}/"] = "folder" if File.directory? f
              files_and_folders[f] = "file" if File.file? f
            end
            files_and_folders["#{file}/"] = "folder"
          else
            files_and_folders[file] = "file"
          end
          next
        end
        raise SignalException.new(1, "Cant find file #{file}") unless File.exists? "#{Dir.pwd}/#{file}"
      end
      return files_and_folders
    end

    def check_files_sha1(files, resolver, tag)
      conflicts = 0
      files.each do |file|
        next if file.ends_with? '/'
        sha1 = resolver.fetch(file, {}).fetch("sha1", nil)
        conflicts += self.check_file_sha1(file, sha1, tag: tag)
      end
      conflicts
    end

    def mark_conflicts(results)
      begin
        updated = results["updated_on_server"]
        deleted = results["deleted"]
        resolver = results['resolved_files']
        overall = 0
        overall += self.check_files_sha1(updated, resolver, "conflict")
        overall += self.check_files_sha1(deleted, resolver, "deleted")
        overall
      rescue => e
        0
      end
    end

    def cp_ds(relative: false)
      prefix = @dataset.get_dataset["bucket_prefix"]
      batch_size = 10000
      pbar = ProgressBar.create(:title => "Download Progress",
                                        :progress_mark => '=',
                                        :format => "%b%i| %c Files downloaded",
                                        :starting_at => 0,
                                        :total => nil,
                                        :autofinish => true)
      parallel_options = {
          in_threads: ParallelThreads,
          in_processes: Cnvrg::CLI::ParallelProcesses,
          isolation: true,
          finish: ->(*args) { pbar.progress += 1 }
      }
      finished = false
      while not finished
        current_batch, marker = @downloader.fetch_files(prefix: prefix, marker: marker, limit: batch_size)
        if marker.blank?
          finished = true
        end
        Parallel.map(current_batch, parallel_options) do |file|
          next if file.end_with? "/"
          cutted_key = relative ? @downloader.cut_prefix(prefix, file) : file
          dest_path = File.join(@dataset.local_path, cutted_key)
          @downloader.download(file, dest_path, decrypt: false)
          file
        end
      end
    end

    # This is for backwards compatibility only and should be removed in future versions:
    def put_commit(commit_sha1)
      response = Cnvrg::API.request(
          "#{@base_resource}/commit/latest",
          'PUT',
          {
              commit_sha1: commit_sha1,
              ignore: true # tells the new server to ignore this api call since its coming from the new CLI
          }
      )
      if response.present?
        msg = response['result']
      else
        msg =  "Can't save changes in the dataset"
      end

      Cnvrg::Result.new(Cnvrg::CLI.is_response_success(response, false), msg)
    end

    def create_progressbar(title, total)
      return ProgressBar.create(
          :title => title,
          :progress_mark => '=',
          :format => "%b>>%i| %p%% %t",
          :starting_at => 0,
          :total => total,
          :autofinish => true
      )
    end


    def upload_multiple_files(commit_sha1, tree, threads: ParallelThreads, force: false, new_branch: false, prefix: '', partial_commit: nil, total: nil)
      begin
        Cnvrg::Logger.log_info("Sending Upload Files request")
        refresh_storage_token
        error = nil
        upload_resp = nil
        10.times do
          upload_resp = Cnvrg::API.request(@base_resource + "upload_files", 'POST_JSON', {commit_sha1: commit_sha1, tree: tree, force: force, override: force, is_branch: new_branch, partial_commit: partial_commit})
          if Cnvrg::CLI.is_response_success(upload_resp, false)
            error = nil
            break
          end
          error = upload_resp
          Cnvrg::Logger.log_method(bind: binding)
          Cnvrg::Logger.log_info("Got an error message from server, #{upload_resp.try(:fetch, "message")}, trying again")
        end
        raise Exception.new("Can't upload data files: #{error["message"]}") if error.present?

        Cnvrg::Logger.log_info("Uploading files")
        results = upload_resp['result'].with_indifferent_access

        if results['files'].blank?
          return 0, []
        end

        if @temp_upload_progressbar.blank?
          @temp_upload_progressbar = ProgressBar.create(:title => "Upload Progress",
                                                        :progress_mark => '=',
                                                        :format => "%b>>%i| %p%% %t",
                                                        :starting_at => 0,
                                                        :total => total,
                                                        :autofinish => true)
        end

        files = results['files']

        progress_semaphore = Mutex.new
        upload_error_files = []
        @temp_upload_progressbar.progress += tree.keys.length - files.length if @temp_upload_progressbar.present?
        Parallel.map((files.keys), in_threads: threads) do |k|
          o = tree[k].merge(files[k])
          success = upload_single_file(nil, o)
          if not success
            upload_error_files << {absolute_path: o[:absolute_path]}
            files.except!(k)
            tree.except!(k)
            Cnvrg::Logger.log_error_message("Error while upload single file #{o["path"]}")
          end
          progress_semaphore.synchronize { @temp_upload_progressbar.progress += 1 if @temp_upload_progressbar.present? }
        end

        blob_ids = files.values.map {|f| f['bv_id']}
        if blob_ids.present?
          dirs = tree.keys.select {|k| tree[k].nil?} || []
          Cnvrg::Logger.info("Sending Upload files save")
          upload_resp = Cnvrg::API.request(@base_resource + "upload_files_save", "POST", {commit: commit_sha1, blob_ids: blob_ids, dirs: dirs})
          unless Cnvrg::CLI.is_response_success(upload_resp, false)
            Cnvrg::Logger.log_method(bind: binding)
            raise Exception.new("Got an error message from server, #{upload_resp.try(:fetch, "message")}")
          end
        end
        Cnvrg::Logger.log_info("Upload Success")
        return files.try(:keys).try(:length), upload_error_files
      rescue => e
        Cnvrg::Logger.log_method(bind: binding)
        Cnvrg::Logger.log_error(e)
        raise e
      end
    end

    def delete_multiple_files(commit_sha1, regex_list)
      begin
        Cnvrg::Logger.log_info("Sending Delete Files request")
        resp = Cnvrg::API.request(
            @base_resource + "delete_files",
            'POST_JSON',
            {
                commit_sha1: commit_sha1,
                regex_list: regex_list,
            }
        )
        unless Cnvrg::CLI.is_response_success(resp, false)
          Cnvrg::Logger.log_method(bind: binding)
          raise Exception.new("Got an error message from server, #{resp.try(:fetch, "message")}")
        end
        Cnvrg::Logger.log_info("Delete Files request Successful")
        return resp["files"], resp["folders"], resp["job_id"]
      rescue => e
        Cnvrg::Logger.log_method(bind: binding)
        Cnvrg::Logger.log_error(e)
        raise e
      end
    end

    def delete_file_chunk(commit_sha1, regex_list, chunk_size, offset)
      retry_count = 0
      begin
        resp = Cnvrg::API.request(
            @base_resource + "delete_files_by_chunk",
            'POST_JSON',
            {
                commit_sha1: commit_sha1,
                regex_list: regex_list,
                chunk_size: chunk_size,
                offset: offset
            }
        )
        unless Cnvrg::CLI.is_response_success(resp, false)
          raise Exception.new("Got an error message from server, #{resp.try(:fetch, "message")}")
        end
        return resp["total_changes"]
      rescue => e
        Cnvrg::Logger.log_method(bind: binding)
        Cnvrg::Logger.log_error(e)

        if retry_count < RETRIES
          sleep(2**retry_count) # Exponential backoff
          retry_count += 1
          retry
        end

        raise e
      end
    end

    def get_delete_progress(commit_sha1, job_id)
      begin
        resp = Cnvrg::API.request(
            @base_resource + "get_delete_progress",
            'POST_JSON',
            {
                commit_sha1: commit_sha1,
                job_id: job_id
            }
        )
        unless Cnvrg::CLI.is_response_success(resp, false)
          Cnvrg::Logger.log_method(bind: binding)
          raise Exception.new("Got an error message from server, #{resp.try(:fetch, "message")}")
        end
        return resp["total_deleted"]
      rescue => e
        Cnvrg::Logger.log_method(bind: binding)
        Cnvrg::Logger.log_error(e)
        raise e
      end
    end

    def request_upload_files(commit_sha1, tree, override, new_branch, partial_commit)
      retry_count = 0
      loop do
        upload_resp = Cnvrg::API.request(@base_resource + "upload_files", 'POST_JSON', {
            commit_sha1: commit_sha1,
            tree: tree,
            override: override,
            force: override,
            is_branch: new_branch,
            partial_commit: partial_commit
        })
        if not (Cnvrg::CLI.is_response_success(upload_resp, false))
          #Cnvrg::Logger.log_method(bind: binding)
          retry_count += 1

          Cnvrg::Logger.log_info("Failed request upload files: #{Time.current}, retry: #{retry_count}")

          if retry_count > 20
            puts "Failed to upload files: #{Time.current}, trying next chunk"
            return nil
          end
          sleep 5
          next
        end
        return upload_resp['result'].with_indifferent_access
      end
    end

    def upload_multiple_files_optimized(files, commit_sha1, threads: 15, chunk_size: 1000, override: false, new_branch: false, prefix: '', partial_commit: nil)
      Thread.report_on_exception = false
      cli = CLI.new
      cli.log_message("Using #{threads} threads with chunk size of #{chunk_size}.", Thor::Shell::Color::GREEN)

      num_files = files.size
      progressbar = create_progressbar("Upload Progress", num_files)
      cli = CLI.new

      # Vars to handle the parallelism
      progress_mutex = Mutex.new
      file_queue = Queue.new
      progress_queue = Queue.new
      dirs_queue = Queue.new
      worker_threads = []
      progress_threads = []
      old_api = false

      # Vars to keep track of uploaded files and directories
      uploaded_files = []

      begin
        # Init working threads that handle the upload of the files:
        threads.times do |i|
          worker_threads[i] = Thread.new do
            # wait for file_queue.close to break the loop
            while file = file_queue.deq
              success = upload_single_file(cli, file)
              file[:success] = success
              if not success
                cli.log_message("Error while uploading file: #{file[:absolute_path]}", Thor::Shell::Color::RED)
                Cnvrg::Logger.log_error_message("Error while upload single file #{file["path"]}")
              end
              while progress_queue.size > 15000
                sleep(0.1)
              end
              progress_queue << file
            end
          end
        end

        dir_thread = Thread.new do
          dirs_to_create = []
          loop do
            dir = dirs_queue.deq(non_block: true) rescue nil
            if dir.nil? && !progressbar.finished?
              sleep 0.2
              Cnvrg::Logger.info("directories thread status: progressbar.finished? #{progressbar.finished?} || dirs_queue.empty? #{dirs_queue.empty?} #{dirs_queue.size}  || dirs_to_create.empty? #{dirs_to_create.empty?} #{dirs_to_create.size}")
            else
              dirs_to_create << dir

              if dirs_to_create.size >= 1000 || progressbar.finished?
                resp = Cnvrg::API.request(@base_resource + "create_dirs", "POST", { dirs: dirs_to_create, commit_sha1: commit_sha1 })
                Cnvrg::Logger.info("uploaded directories chunk, finished with #{resp}")
                if resp == false # if resp is false it means 404 which is old server
                  old_api = true
                  break
                end
                unless Cnvrg::CLI.is_response_success(resp, false)
                  dirs_to_create = []
                  time = Time.current
                  Cnvrg::Logger.log_error_message("Failed to create dirs: #{time}, #{resp.try(:fetch, "message")}")
                  next
                end
                dirs_to_create = []
              end
              break if progressbar.finished? && dirs_queue.empty? && dirs_to_create.empty?
            end
          end
        end

        # init the thread that handles the file upload progress and saving them in the server
        threads.times do |i|
          progress_threads[i] = Thread.new do
            loop do
              file = progress_queue.deq(non_block: true) rescue nil # to prevent deadlocks
              unless file.nil?
                blob_ids = []
                progress_mutex.synchronize {
                  progressbar.progress += 1
                  uploaded_files.append(file) if file[:success]

                  if uploaded_files.size >= chunk_size or progressbar.finished?
                    blob_ids = uploaded_files.map {|f| f['bv_id']}
                    uploaded_files = []
                  end
                }

                if blob_ids.present?
                  random_id = (0...10).map { ('a'..'z').to_a[rand(26)] }.join
                  refresh_storage_token
                  Cnvrg::Logger.info("chunk #{random_id}: Finished uploading chunk of #{chunk_size} files, Sending Upload files save")
                  retry_count = 0
                  loop do
                    upload_resp = Cnvrg::API.request(@base_resource + "upload_files_save", "POST", {commit: commit_sha1, blob_ids: blob_ids})

                    if not (Cnvrg::CLI.is_response_success(upload_resp, false))
                      retry_count += 1
                      Cnvrg::Logger.log_error_message("chunk #{random_id}: Failed request save files: #{Time.current}, retry: #{retry_count}")
                      if retry_count > 20
                        puts "chunk #{random_id}: Failed to save files: #{Time.current}, trying next chunk"
                        break
                      end
                      sleep 5
                      next
                    end
                    Cnvrg::Logger.info("chunk #{random_id}: Chunk saved on server")
                    break
                  end
                end
              else
                sleep(0.1)
              end
              Cnvrg::Logger.info("progress_threads: progressbar.finished? #{progressbar.finished?}")
              if progressbar.finished?
                Cnvrg::Logger.info("Progress bar finished closing queues")
                file_queue.close
                progress_queue.close
                Thread.exit
              end
            end
          end
        end

        file_chunks = files.each_slice(chunk_size).to_a
        # Fetch the required files from the server:
        num_chunks = (num_files / 1000.0).ceil
        chunk_index = 0
        Parallel.map((file_chunks), in_threads: threads) do |chunk|
          chunk_index += 1
          self_chunk_index = chunk_index
          files_chunk = chunk.map { |p| p.gsub(/^\.\//, '') }
          Cnvrg::Logger.info("chunk #{self_chunk_index} / #{num_chunks}: Generating chunk idx")
          tree = @dataset.generate_chunked_idx(files_chunk, prefix: prefix, threads: threads, cli: cli)
          Cnvrg::Logger.info("chunk #{self_chunk_index} / #{num_chunks}: Finished Generating chunk idx")

          # Handle directories:
          unless old_api
            while dirs_queue.size > 5000
              sleep(0.1)
            end
          end
          new_dirs = tree.keys.select { |k| tree[k].nil? }
          if new_dirs.blank?
            ## we need to send 1 file so we will inflated dirs from in case when we dont have folders in the tree
            file = tree.keys.find { |k| tree[k] != nil }
            dirs_queue.push(file) unless old_api
          end
          new_dirs.each { |dir| dirs_queue.push dir }

          Cnvrg::Logger.info("chunk #{self_chunk_index} / #{num_chunks}: Getting files info from server")
          results = request_upload_files(commit_sha1, tree, override, new_branch, partial_commit)
          Cnvrg::Logger.info("chunk #{self_chunk_index} / #{num_chunks}: Finished Getting files info from server")
          next unless results

          if results['files'].blank?
            Cnvrg::Logger.info("chunk #{self_chunk_index} / #{num_chunks}: no files to upload skipping chunk")
            progress_mutex.synchronize { progressbar.progress += tree.keys.length }
            next
          end

          files_to_upload = results['files']
          Cnvrg::Logger.info("chunk #{self_chunk_index} / #{num_chunks}: number of files to upload in this chunk: #{tree.keys.length - files_to_upload.length}")
          progress_mutex.synchronize {
            progressbar.progress += tree.keys.length - files_to_upload.length
          }

          files_to_upload.keys.each do |key|
            while file_queue.size > 5000
              sleep(0.1)
            end
            file_queue.push tree[key].merge(files_to_upload[key])
          end
        end

        Cnvrg::Logger.info("Waiting dir_thread to finish")
        dir_thread.join
        dirs_queue.close
        Cnvrg::Logger.info("Waiting progress_thread to finish")
        progress_threads.each(&:join)
        Cnvrg::Logger.info("Waiting workers to finish")
        worker_threads.each(&:join)
        Thread.report_on_exception = true
      rescue => e
        Cnvrg::Logger.log_method(bind: binding)
        Cnvrg::Logger.log_error(e)
        raise e
      end
    end

    def upload_single_file(cli, file)
      success = false
      begin
        file = file.as_json
        Cnvrg::Logger.log_info("Uploading #{file["absolute_path"]}")
        @downloader.safe_upload(file["path"], file["absolute_path"])
        success = true
        Cnvrg::Logger.log_info("#{file["absolute_path"]} uploaded.")
      rescue => e
        Cnvrg::Logger.log_error_message("Error while upload single file #{file["path"]}")
        Cnvrg::Logger.log_error(e)
      end
      success
    end

    def upload_file(absolute_path, relative_path, commit_sha1)
      file_name = File.basename relative_path
      file_size = File.size(absolute_path).to_f
      mime_type = MimeMagic.by_path(absolute_path)
      content_type = !(mime_type.nil? or mime_type.text?) ? mime_type.type : "text/plain"
      sha1 =  OpenSSL::Digest::SHA1.file(absolute_path).hexdigest
      if (absolute_path.include? "_tags.yml" or absolute_path.include? "_tags.yaml")
        is_valid = false
        begin
        content = open(absolute_path).read()
        hash = YAML.load(open(absolute_path).read())
          # if level 1 keys count is 1
          if hash.keys.count == 1
            if hash["tags"].present?
              is_valid = true
            elsif hash[hash.keys.first].class != Hash
              is_valid = true
            end
          # if level 1 keys count is greater than 1
          elsif hash.keys.count > 1
            if hash["tags"].present? and hash["tags"].class == Hash
              is_valid = false
            else
              is_valid = true
            end
          end
        rescue
          is_valid = false
        end

        if is_valid
          upload_resp = Cnvrg::API.request(@base_resource + "upload_file", 'POST_FILE', {absolute_path: absolute_path, relative_path: relative_path,
                                                                                         commit_sha1: commit_sha1, file_name: file_name,
                                                                                         file_size: file_size, file_content_type: content_type, sha1: sha1, content: content})
        else
          puts("#{absolute_path} is invalid")
          puts("Please check yaml structure.")
        end
      else
        upload_resp = Cnvrg::API.request(@base_resource + "upload_file", 'POST_FILE', {absolute_path: absolute_path, relative_path: relative_path,
                                                                                       commit_sha1: commit_sha1, file_name: file_name,
                                                                                       file_size: file_size, file_content_type: content_type, sha1: sha1})


      end

      if Cnvrg::CLI.is_response_success(upload_resp, false)
        s3_res = upload_large_files_s3(upload_resp, absolute_path)

        return s3_res
      end
    end
    def upload_tar_file(absolute_path, relative_path, commit_sha1)
      begin
        file_name = File.basename relative_path
        file_size = File.size(absolute_path).to_f
        mime_type = MimeMagic.by_path(absolute_path)
        content_type = !(mime_type.nil? or mime_type.text?) ? mime_type.type : "text/plain"
        begin
          chunked_bytes = [100, (file_size*0.01)].min
          total_yanked = ""
          open(absolute_path, "rb") do |f|
            total_yanked = f.read(chunked_bytes)
          end
          if !total_yanked.empty?
            sha1 =  OpenSSL::Digest::SHA1.hexdigest(total_yanked)
          else
            sha1 =  OpenSSL::Digest::SHA1.file(absolute_path).hexdigest
          end
        rescue
          sha1 =  OpenSSL::Digest::SHA1.file(absolute_path).hexdigest
        end

        upload_resp = Cnvrg::API.request(@base_resource + "upload_tar_file", 'POST_FILE', {absolute_path: absolute_path, relative_path: relative_path,
                                                                                           commit_sha1: commit_sha1, file_name: file_name,
                                                                                           file_size: file_size, file_content_type: content_type, sha1: sha1,
                                                                                            new_version:true})
        if Cnvrg::CLI.is_response_success(upload_resp, false)
          path = upload_resp["result"]["path"]
          s3_res = upload_large_files_s3(upload_resp, absolute_path)
          if s3_res
            # Cnvrg::API.request(@base_resource + "update_s3", 'POST', {path: path, commit_id: upload_resp["result"]["commit_id"],
            #                                                           blob_id: upload_resp["result"]["id"]})
            return true
          end
        else
          return false
        end
      rescue => e
        #puts e.message
        return false
      end
    end


    def upload_log_file(absolute_path, relative_path, log_date)
      file_name = File.basename relative_path
      file_size = File.size(absolute_path).to_f
      content_type = "text/x-log"
      upload_resp = Cnvrg::API.request("/users/#{@owner}/" + "upload_cli_log", 'POST_FILE', {absolute_path: absolute_path, relative_path: relative_path,
                                                                                             file_name: file_name, log_date: log_date,
                                                                                             file_size: file_size, file_content_type: content_type})
      if Cnvrg::CLI.is_response_success(upload_resp, false)
        path = upload_resp["result"]["path"]
        s3_res = upload_small_files_s3(path, absolute_path, "text/plain")
      end
      if s3_res
        return true
      end
      return false

    end
    def upload_data_log_file(absolute_path, relative_path,data_commit_sha)
      file_name = File.basename relative_path
      file_size = File.size(absolute_path).to_f
      content_type = "text/x-log"
      upload_resp = Cnvrg::API.request("/users/#{@owner}/" + "upload_data_log", 'POST_FILE', {absolute_path: absolute_path, relative_path: relative_path,
                                                                                             file_name: file_name, log_date: Time.now,
                                                                                             file_size: file_size, file_content_type: content_type,
                                                                                              data_commit_sha1:data_commit_sha})
      if Cnvrg::CLI.is_response_success(upload_resp, false)
        path = upload_resp["result"]["path"]
        s3_res = upload_small_files_s3(path, absolute_path, "text/plain")
      end
      if s3_res
        return true
      end
      return false

    end


    def upload_exec_file(absolute_path, image_name, commit_id)
      file_name = File.basename absolute_path
      file_size = File.size(absolute_path).to_f
      content_type = "application/zip"
      begin
        upload_resp = Cnvrg::API.request("users/#{@owner}/images/" + "upload_config", 'POST_FILE', {relative_path: absolute_path,
                                                                                                    file_name: file_name,
                                                                                                    image_name: image_name,
                                                                                                    file_size: file_size,
                                                                                                    file_content_type: content_type,
                                                                                                    project_slug: @project_slug,
                                                                                                    commit_id: commit_id})
        # puts upload_resp
        if Cnvrg::CLI.is_response_success(upload_resp, false)
          if upload_resp["result"]["image"] == -1
            return -1
          end
          path = upload_resp["result"]["path"]
          s3_res = upload_small_files_s3(path, absolute_path, content_type)

        end
        if s3_res
          return upload_resp["result"]["id"]
        end
        return false
      rescue SignalException

        say "\nAborting"
        exit(1)
      end

    end


    def upload_image(absolute_path, image_name, owner, is_public, is_base, dpkg, libraries, bash, message, commit_id)
      file_name = File.basename absolute_path
      file_size = File.size(absolute_path).to_f
      if is_base

        content_type = "application/zip"
      else
        content_type = "application/gzip"
      end
      begin
        upload_resp = Cnvrg::API.request("users/#{owner}/images/" + "upload_cnvrg", 'POST_FILE', {relative_path: absolute_path,
                                                                                                  file_name: file_name,
                                                                                                  image_name: image_name,
                                                                                                  file_size: file_size,
                                                                                                  file_content_type: content_type,
                                                                                                  is_public: is_public,
                                                                                                  project_slug: @project_slug,
                                                                                                  commit_id: commit_id,
                                                                                                  dpkg: dpkg,
                                                                                                  py2: libraries,
                                                                                                  py3: libraries,
                                                                                                  bash_history: bash,
                                                                                                  commit_message: message,
                                                                                                  is_base: is_base})
        # puts upload_resp
        if Cnvrg::CLI.is_response_success(upload_resp, false)
          path = upload_resp["result"]["path"]
          s3_res = upload_small_files_s3(path, absolute_path, content_type)
          if s3_res
            commit_resp = Cnvrg::API.request("users/#{owner}/images/#{upload_resp["result"]["id"]}/" + "commit", 'GET')
            if Cnvrg::CLI.is_response_success(commit_resp, false)
              return commit_resp["result"]["image"]
            else
              return false
            end

          end
        end
        return false
      rescue => e
      end

    end

    def upload_cnvrg_image(absolute_path, image_name,secret)
      file_name = File.basename relative_path
      file_size = File.size(absolute_path).to_f
      mime_type = MimeMagic.by_path(absolute_path)
      content_type = !(mime_type.nil? or mime_type.text?) ? mime_type.type : "text/plain"
      upload_resp = Cnvrg::API.request("images/#{image_name}/upload_file", 'POST_FILE', {absolute_path: absolute_path, relative_path: absolute_path,
                                                                                     file_name: file_name,
                                                                                     file_size: file_size, file_content_type: content_type,
                                                                                     secret: secret})
      if Cnvrg::CLI.is_response_success(upload_resp, false)
        path = upload_resp["result"]["path"]
        s3_res = upload_large_files_s3(upload_resp, absolute_path)
        if s3_res
          Cnvrg::API.request(@base_resource + "update_s3", 'POST', {path: path, commit_id: upload_resp["result"]["commit_id"],
                                                                    blob_id: upload_resp["result"]["id"]})
          return true
        end
      end
      return false

    end

    def download_image(file_path_to_store, image_slug, owner)


      download_resp = Cnvrg::API.request("users/#{owner}/images/#{image_slug}/" + "download", 'GET')
      path = download_resp["result"]["path"]

      if Cnvrg::CLI.is_response_success(download_resp, false)
        begin
          open(file_path_to_store, 'w+') do |file|
            file << open(path).read
          end

          return true
        rescue => e
          return false
        end

        return true
      else
        return false
      end


    end

    def upload_large_files_s3(upload_resp, file_path)
      begin
        sts_path = upload_resp["result"]["path_sts"]

        retries = 0
        success= false
        while !success and retries < 20
          begin
            if !Helpers.is_verify_ssl
              body = open(sts_path, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
            else
              body = open(sts_path).read
            end
            success = true
          rescue => e
            retries +=1
            sleep(5)

          end
        end
        if !success
          return false
        end
        split = body.split("\n")
        key = split[0]
        iv = split[1]
        is_s3 = upload_resp["result"]["is_s3"]
        access =  Cnvrg::Helpers.decrypt(key, iv, upload_resp["result"]["sts_a"])

        secret =  Cnvrg::Helpers.decrypt(key,iv, upload_resp["result"]["sts_s"])

        session =  Cnvrg::Helpers.decrypt(key,iv, upload_resp["result"]["sts_st"])
        region =  Cnvrg::Helpers.decrypt(key,iv, upload_resp["result"]["region"])

        bucket =  Cnvrg::Helpers.decrypt(key,iv, upload_resp["result"]["bucket"])
        server_side_encryption =upload_resp["result"]["server_side_encryption"]
        use_accelerate_endpoint = false
        if is_s3 or is_s3.nil?

          use_accelerate_endpoint =true
          client = Aws::S3::Client.new(
              :access_key_id =>access,
              :secret_access_key => secret,
              :session_token => session,
              :region => region,
              :http_open_timeout => 60, :retry_limit => 20)
        else
          endpoint = Cnvrg::Helpers.decrypt(key,iv, upload_resp["result"]["endpoint"])
          use_accelerate_endpoint = false
          client = Aws::S3::Client.new(
              :access_key_id =>access,
              :secret_access_key => secret,
              :region => region,
              :endpoint=> endpoint,:force_path_style=> true,:ssl_verify_peer=>false,
              :http_open_timeout => 60, :retry_limit => 20)
        end


        if !server_side_encryption
          options = {:use_accelerate_endpoint => use_accelerate_endpoint}
        else
          options = {:use_accelerate_endpoint => use_accelerate_endpoint, :server_side_encryption => server_side_encryption}
        end




        s3 = Aws::S3::Resource.new(client: client)

        resp = s3.bucket(bucket).
            object(upload_resp["result"]["path"]+"/"+File.basename(file_path)).
            upload_file(file_path,options)


        return resp

      rescue => e
        #puts e.message
        return false

      end
      return true

    end


    def upload_small_files_s3(url_path, file_path, content_type)
      url = URI.parse(url_path)
      file = File.open(file_path, "rb")
      body = file.read
      begin
        Net::HTTP.start(url.host) do |http|
          http.send_request("PUT", url.request_uri, body, {
              "content-type" => content_type,
          })
        end
        return true
      rescue Interrupt
        return false
      rescue
        return false
      end
    end

    def upload_url(file_path)
      response = Cnvrg::API.request(@base_resource + "upload_url", 'POST', {file_s3_path: file_path})
      if Cnvrg::CLI.is_response_success(response, false)
        return response
      else
        return nil
      end

    end

    def delete_file(absolute_path, relative_path, commit_sha1)
      response = Cnvrg::API.request(@base_resource + "delete_file", 'DELETE', {absolute_path: absolute_path, relative_path: relative_path, commit_sha1: commit_sha1})
      return Cnvrg::CLI.is_response_success(response, false)
    end

    def delete_dir(absolute_path, relative_path, commit_sha1)
      response = Cnvrg::API.request(@base_resource + "delete_dir", 'DELETE', {absolute_path: absolute_path, relative_path: relative_path, commit_sha1: commit_sha1})
      return Cnvrg::CLI.is_response_success(response, false)
    end

    def create_dir(absolute_path, relative_path, commit_sha1)
      response = Cnvrg::API.request(@base_resource + "create_dir", 'POST', {absolute_path: absolute_path, relative_path: relative_path, commit_sha1: commit_sha1})
      return Cnvrg::CLI.is_response_success(response, false)
    end
    def download_list_files_in_query(response, dataset_home)
      sts_path = response["path_sts"]
      if !Helpers.is_verify_ssl
        body = open(sts_path, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
      else
        body = open(sts_path).read
      end
      split = body.split("\n")
      key = split[0]
      iv = split[1]

      access =  Cnvrg::Helpers.decrypt(key, iv, response["sts_a"])

      secret =  Cnvrg::Helpers.decrypt(key,iv, response["sts_s"])

      session =  Cnvrg::Helpers.decrypt(key,iv, response["sts_st"])
      region =  Cnvrg::Helpers.decrypt(key,iv, response["region"])

      bucket =  Cnvrg::Helpers.decrypt(key,iv, response["bucket"])
      is_s3 = response["is_s3"]
      if is_s3 or is_s3.nil?
        client = Aws::S3::Client.new(
            :access_key_id =>access,
            :secret_access_key => secret,
            :session_token => session,
            :region => region,
            :http_open_timeout => 60, :retry_limit => 20)
      else
        endpoint = Cnvrg::Helpers.decrypt(key,iv, response["endpoint_url"])
        client = Aws::S3::Client.new(
            :access_key_id =>access,
            :secret_access_key => secret,
            :region => region,
            :endpoint=> endpoint,:force_path_style=> true,:ssl_verify_peer=>false,
            :http_open_timeout => 60, :retry_limit => 20)
      end
      list_files = response["files"]
      parallel_options = {
          :progress => {
              :title => "Download Progress",
              :progress_mark => '=',
              :format => "%b>>%i| %p%% %t",
              :starting_at => 0,
              :total => list_files.size,
              :autofinish => true
          },
          in_threads: ParallelThreads
      }
      download_count = 0
      Parallel.map((list_files), parallel_options) do |f|
        file_key =  Cnvrg::Helpers.decrypt(key,iv, f["path"])
        begin
        begin
          dir = File.dirname f["fullpath"]
          FileUtils.mkdir_p(dataset_home+"/"+ dir) unless File.exist? (dataset_home+"/"+ dir)
        end

        File.open(dataset_home+"/"+f["fullpath"], 'w+') do |file|
          resp = client.get_object({bucket:bucket,
                                    key:file_key}, target: file)
        end
        download_count += 1
        rescue
        end

      end
      if download_count == list_files.size
        return true
      else
        return false
      end




    end


    def download_file_s3(absolute_path, relative_path, project_home, conflict=false, commit_sha1=nil, as_link=false)
      begin
        res = Cnvrg::API.request(@base_resource + "download_file", 'POST', {absolute_path: absolute_path, relative_path: relative_path, commit_sha1: commit_sha1 ,new_version:true, as_link:as_link})
        Cnvrg::CLI.is_response_success(res, false)
          if res["result"]
            file_url = res["result"]["file_url"]

            if as_link
              return res["result"]
            end
            # begin
            #   if !Helpers.is_verify_ssl
            #     tempfile = Down.download(file_url,open_timeout: 60,ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE )
            #
            #   else
            #     tempfile = Down.download(file_url,open_timeout: 60)
            #
            #   end
            #
            #   FileUtils.move(tempfile.path, project_home+"/"+ absolute_path)
            #   return true
            # rescue
            #
            # end
            download_resp = res
            filename = download_resp["result"]["filename"]

            absolute_path += ".conflict" if conflict
            sts_path = download_resp["result"]["path_sts"]
            retries = 0
            success= false
            while !success and retries < 20
              begin
                if !Helpers.is_verify_ssl
                  body = open(sts_path, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
                else
                  body = open(sts_path).read
                end
                success = true
              rescue => e
                retries +=1
                sleep(5)

              end
            end
            if !success
              return false
            end
            split = body.split("\n")
            key = split[0]
            iv = split[1]

            access =  Cnvrg::Helpers.decrypt(key, iv, download_resp["result"]["sts_a"])

            secret =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["sts_s"])

            session =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["sts_st"])
            region =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["region"])

            bucket =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["bucket"])
            file_key =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["key"])

            is_s3 = download_resp["result"]["is_s3"]
            if is_s3 or is_s3.nil?
              client = Aws::S3::Client.new(
                  :access_key_id =>access,
                  :secret_access_key => secret,
                  :session_token => session,
                  :region => region,
                  :http_open_timeout => 60, :retry_limit => 20)
            else
              endpoint = Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["endpoint_url"])
              client = Aws::S3::Client.new(
                  :access_key_id =>access,
                  :secret_access_key => secret,
                  :region => region,
                  :endpoint=> endpoint,:force_path_style=> true,:ssl_verify_peer=>false,
                  :http_open_timeout => 60, :retry_limit => 20)
            end

            File.open(project_home+"/"+absolute_path, 'w+') do |file|
              resp = client.get_object({bucket:bucket,
                                        key:file_key}, target: file)
            end
            return true
          end

      rescue => e
        return false

      end
    end

    def download_data_file(commit_sha1, dataset_home)
      begin
        res = Cnvrg::API.request(@base_resource + "download_data_file", 'POST', {commit_sha1: commit_sha1,new_version:true})
        Cnvrg::CLI.is_response_success(res, false)
        if res["result"]
          download_resp = res
          filename = download_resp["result"]["filename"]

          sts_path = download_resp["result"]["path_sts"]
          if !Helpers.is_verify_ssl
            body = open(sts_path, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
          else
            body = open(sts_path).read
          end
          split = body.split("\n")
          key = split[0]
          iv = split[1]


          access =  Cnvrg::Helpers.decrypt(key, iv, download_resp["result"]["sts_a"])

          secret =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["sts_s"])

          session =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["sts_st"])
          region =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["region"])

          bucket =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["bucket"])
          file_key =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["key"])

          is_s3 = download_resp["result"]["is_s3"]
          if is_s3 or is_s3.nil?
            client = Aws::S3::Client.new(
                :access_key_id =>access,
                :secret_access_key => secret,
                :session_token => session,
                :region => region,
                :http_open_timeout => 60, :retry_limit => 20)
          else
            endpoint = Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["endpoint_url"])
            client = Aws::S3::Client.new(
                :access_key_id =>access,
                :secret_access_key => secret,
                :region => region,
                :endpoint=> endpoint,:force_path_style=> true,:ssl_verify_peer=>false,
                :http_open_timeout => 60, :retry_limit => 20)
          end


          File.open(dataset_home+"/"+filename, 'w+') do |file|
            resp = client.get_object({bucket: bucket,
                                  key: file_key }, target: file)
          end
          return filename
        end

      rescue => e
        return false

      end
    end

    def download_file(absolute_path, relative_path, project_home, conflict=false)
      res = Cnvrg::API.request(@base_resource + "download_file", 'POST', {absolute_path: absolute_path, relative_path: relative_path})
      Cnvrg::CLI.is_response_success(res, false)
      if res["result"]
        res = res["result"]
        return false if res["link"].empty? or res["filename"].empty?
        filename = res["filename"]
        file_location = absolute_path.gsub(/#{filename}\/?$/, "")

        FileUtils.mkdir_p project_home + "/" + file_location
        filename += ".conflict" if conflict

        File.open("#{project_home}/#{file_location}/#{filename}", "w+") do |file|
          file.write open(res["link"]).read
        end
      else
        return false
      end
      return true
    end

    def delete_commit_files_local(deleted)
      begin
        FileUtils.rm_rf(deleted) unless (deleted.nil? or deleted.empty?)
        return Cnvrg::Result.new(true, '')
      rescue => e
        return Cnvrg::Result.new(false, '')
      end
    end

    def download_dir(dataset_home, absolute_path)
      FileUtils.mkdir_p("#{dataset_home}/#{absolute_path}")
    end

    def revoke_download_dir(absolute_path)
      puts FileUtils.rmtree("#{absolute_path}")
    end

    def revoke_download_file(absolute_path, filename, conflict=false)
      begin
        file_location = absolute_path.gsub(/#{filename}\/?$/, "")

        filename += ".conflict" if conflict
        FileUtils.remove("#{file_location}/#{filename}")
        return true
      rescue
        return false
      end
    end

    def revoke_download(tar_files, extracted_files)
      begin
        FileUtils.rm_rf(tar_files) unless (tar_files.nil? or tar_files.empty?)
        FileUtils.rm_rf(extracted_files) unless (extracted_files.nil? or extracted_files.empty?)
      rescue => e
        return false
      end
      return true
    end

    def delete_commit(commit_sha1)
      response = Cnvrg::API.request("#{base_resource}/commit/#{commit_sha1}", 'DELETE')
      Cnvrg::CLI.is_response_success(response, true)
      return response
    end

    def get_commit(commit_sha1)
      response = Cnvrg::API.request("#{base_resource}/commit/#{commit_sha1}", 'GET')
      Cnvrg::CLI.is_response_success(response, true)
      return response
    end

    def start_commit(new_branch, force=false, chunks: 0, dataset: @dataset, message:nil)
      #if we are pushing with force or to branch we dont need to send current/next commit cause we want to
      # create a new commit.
      idx = {}
      commit = idx[:commit]
      next_commit = idx[:next_commit]
      response = Cnvrg::API.request(
          "#{base_resource}/commit/start",
          'POST',
          {
              dataset_slug: @dataset_slug,
              new_branch: new_branch,
              force:force,
              username: @owner,
              current_commit: commit,
              next_commit: next_commit,
              total_chunks: chunks,
              message: message
          }
      )
      Cnvrg::CLI.is_response_success(response, true)
      response
    rescue => e
      false
    end

    def end_commit(commit_sha1, force, success: true, uploaded_files: 0, commit_type: nil, auto_cache: false, external_disk: nil)
      counter = 0
      begin
        counter += 1
        response = Cnvrg::API.request(
            "#{base_resource}/commit/end",
            'POST',
            {
                commit_sha1: commit_sha1,
                force:force,
                success: success,
                uploaded_files: uploaded_files,
                commit_type: commit_type,
                auto_cache: auto_cache,
                external_disk: external_disk
            }
        )
        is_success = Cnvrg::CLI.is_response_success(response, false)
        raise Exception.new("Invalid response #{response}") unless is_success
        return response
      rescue => e
        retry if counter <= 20
        return false
      end
    end

    def end_commit_tar(commit_sha1, cur_idx)
      response = Cnvrg::API.request("#{base_resource}/commit/end_tar", 'POST', {commit_sha1: commit_sha1, idx: cur_idx})
      return response
    end

    def rollback_commit(commit_sha1)
      response = Cnvrg::API.request("#{base_resource}/commit/rollback", 'POST', {commit_sha1: commit_sha1})
      Cnvrg::CLI.is_response_success(response, false)
    end

    def clone_in_chunks(commit: 'latest', chunk_size: 1000)
      begin

      end
    end

    def get_trees(commit: "latest")
      response = Cnvrg::API.request("#{@base_resource}/clone_trees", 'POST',{commit: commit})
      return nil unless Cnvrg::CLI.is_response_success(response, false)
      response['result']['files']
    end

    def get_clone_chunk(latest_id: nil, chunk_size: 1000, commit: 'latest', cache_link: false)
      response = Cnvrg::API.request("#{@base_resource}/clone_chunk", 'POST',{commit: commit, chunk_size: chunk_size, latest_id: latest_id, cache_link: cache_link})
      unless Cnvrg::CLI.is_response_success(response, false)
        Cnvrg::Logger.log_info("#{{commit: commit, chunk_size: chunk_size, latest_id: latest_id}}")
        return nil
      end
      response['result']['files']
    end

    def download_files_in_chunks(files, chunk_size: 1000, conflict: false, commit: 'latest', progress: nil)
      begin
        files.each_slice(chunk_size).each do |files|
          download_files_chunk(files, conflict: conflict, progress: progress)
        end
        return Cnvrg::Result.new(true, "Download Completed")
      rescue Exception => e
        return Cnvrg::Result.new(false, "Can`t download files")
      end
    end

    def download_files_chunk(files, conflict: false, progress: nil)
      (1..5).each do |i|
        response = Cnvrg::API.request("users/#{@owner}/datasets/#{@dataset_slug}/download_multi", 'POST', {files: files})
        next unless Cnvrg::CLI.is_response_success(response, false) #trying to api request 5 times.
        files_to_download = response['files']
        data_home = "#{Dir.pwd}/#{response['name']}"
        res = download_multiple_files_s3(files_to_download, data_home, conflict: conflict, read_only: false, progressbar: progress)
        next unless res.is_success? #try again..
        return files_to_download['keys'].length
      end
    end

    def download_multiple_chunks(commit, chunk_size=1000, progress: nil)
      begin
      last_chunk_size = chunk_size
      q = { commit: commit, chunk_size: chunk_size}
      overall = 0
      while last_chunk_size > 0
        response = Cnvrg::API.request("users/#{@owner}/datasets/#{@dataset_slug}/clone", 'POST', q)
        if Cnvrg::CLI.is_response_success(response, false) 
          files = response['files']
          data_home = "#{Dir.pwd}/#{response['name']}"
          last_chunk_size = files['keys'].length
          break if last_chunk_size == 0
          res = download_multiple_files_s3(files, data_home, read_only: false, progressbar: progress)
          overall += last_chunk_size
          q[:latest] = files['latest']
        else
          last_chunk_size = 0
        end
      end
      Cnvrg::Result.new(true, "Cloned #{overall} files!")
      rescue => e
        Cnvrg::Result.new(false, "Cant download chunk", e.message, e.backtrace)

      end
    end

    def last_valid_commit()
      begin
        response = Cnvrg::API.request("#{base_resource}/last_valid_commit", 'GET')
        Cnvrg::CLI.is_response_success(response, true)
        return response
      rescue => e
        return false
      end
    end

    def download_multiple_files_s3(files, project_home, conflict: false, progressbar: nil, read_only:false, flatten: false, threads: 15, cache_link: false)
      begin
        refresh_storage_token
        parallel_options = {
            in_threads: threads,
            isolation: true
        }

        Parallel.map(files["keys"], parallel_options) do |f|
          begin
            file_path = f['name']
            file_path = File.basename(f['name']) if flatten
            local_path = @dataset.local_path + '/' + file_path
            Cnvrg::Logger.log_info("Downloading #{local_path}")
            if local_path.end_with? "/"
              @downloader.mkdir(local_path, recursive: true)
              next
            end
              # blob
            local_path = "#{local_path}.conflict" if conflict
            storage_path = f["path"]
              # if File.exists? local_path
              #   Cnvrg::Logger.log_info("Trying to download #{local_path} but its already exists, skipping..")
              #   next
              # end
            if cache_link
              cached_commits = f['cached_commits']

              if cached_commits.present?
                next if @downloader.link_file(cached_commits, local_path, @dataset.title, f['name'])
              end
            end

            resp = @downloader.safe_download(storage_path, local_path)
            progressbar.progress += 1 if progressbar.present?
            Cnvrg::Logger.log_info("Download #{local_path} success resp: #{resp}")
          rescue => e
            Cnvrg::Logger.log_error(e)
          end
        end
        return Cnvrg::Result.new(true,"Downloaded successfully")
      rescue => e
          Cnvrg::Logger.log_error(e)
          return Cnvrg::Result.new(false,"Could not download some files", e.message, e.backtrace)
        end
      end
  end
end
