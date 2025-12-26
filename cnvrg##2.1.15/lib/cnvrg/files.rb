require 'mimemagic'
require 'aws-sdk-s3'
require 'URLcrypt'
require 'tempfile'
require 'net/http'
require 'cnvrg/result'
module Cnvrg
  class Files
    ParallelThreads = Cnvrg::Helpers.parallel_threads
    VALID_FILE_NAME = /[\x00\\\*\?\"<>\|]/
    LARGE_FILE=1024*1024*5
    MULTIPART_SPLIT=10000000

    attr_reader :base_resource

    def initialize(owner, project_slug, project_home: '', project: nil, progressbar: nil, cli: nil, options: {})
      @project_slug = project_slug
      @owner = owner
      @base_resource = "users/#{owner}/projects/#{project_slug}/"
      @project_home = project_home.presence || Cnvrg::CLI.get_project_home
      @project = project
      @client = nil
      if @project.present?
        @client = @project.get_storage_client
      end
      @progressbar = progressbar
      @custom_progess = false
      @cli = cli
      @options = options
      @token_issue_time = Time.current
    end

    def refresh_storage_token
      current_time = Time.current
      if current_time - @token_issue_time > 3.hours
        @client = @project.get_storage_client
        @token_issue_time = Time.current
      end
    end

    def self.valid_file_name?(fullpath)
      VALID_FILE_NAME.match(fullpath).blank?
    end


    def download_commit(sha1)
      response = @project.clone(false, sha1)
      log_error("Cant download commit #{sha1}") unless Cnvrg::CLI.is_response_success response, false
      commit_sha1 = response["result"]["commit"]
      files = response["result"]["tree"].keys
      log_progress("Downloading #{files.size} Files")
      idx = {commit: commit_sha1, tree: response["result"]["tree"]}
      @progressbar ||= create_progressbar(files.size, "Download Progress")
      download_files(files, commit_sha1, progress: @progressbar)
      @progressbar.finish if @custom_progess
      Project.verify_cnvrgignore_exist(@project_slug, false)
      @project.set_idx(idx)
      log("Done")
      log("Downloaded #{files.size} files")
    end

    def get_upload_options(number_of_items: 0, progress: false)
      options = {
          in_processes: Cnvrg::CLI::ParallelProcesses,
          in_thread: Cnvrg::CLI::ParallelThreads,
          isolation: true
      }
      if progress
        options[:progress] = {
            :title => "Upload Progress",
            :progress_mark => '=',
            :format => "%b>>%i| %p%% %t",
            :starting_at => 0,
            :total => number_of_items,
            :autofinish => true
        }
      end
      options
    end

    def upload_files_old(files_list, commit_sha1, progress: nil)
      # Parallel.map(files_list) do |file|
      files_list.each do |file|
        Cnvrg::Helpers.try_until_success{self.upload_old("#{@project_home}/#{file}", file, commit_sha1)}
        progress.progress += 1
      end
    end

    def upload_multiple_files(files_list, commit_sha1, progress: nil, suppress_exceptions: false, chunk_size: 100)
      #open files on the server.
      Cnvrg::Logger.log_info("Uploading project files")
      return if files_list.blank?
      if Cnvrg::Helpers.server_version < 1
        Cnvrg::Logger.log_info("Upload files to older server..")
        return self.upload_files_old(files_list, commit_sha1, progress: progress)
      end

      blob_ids = []
      buffered_errors = {}
      files_list.each_slice(chunk_size).each do |chunk_of_files|
        Cnvrg::Logger.log_info("Upload chunk")
        parsed_chunk_of_files = chunk_of_files.map{|x| [x, self.parse_file(x)] if self.parse_file(x)}.compact.to_h

        resp = Cnvrg::API.request(@base_resource + "upload_files", 'POST', {
            files: parsed_chunk_of_files,
            commit: commit_sha1
        })
        unless Cnvrg::CLI.is_response_success(resp, false)
          raise StandardError.new("Cant upload files to the server")
        end
        # resolve bucket
        res = resp['result']
        files = res['files']

        #upload files
        blob_id_chunk = Parallel.map(files.keys, in_threads: ParallelThreads) do |file|
          begin
            upload_single_file(files[file].merge(parsed_chunk_of_files[file]))
          rescue => e
            Cnvrg::CLI.log_message("Failed to upload #{file}: #{e.message}", 'red') unless suppress_exceptions
            Cnvrg::Logger.log_error(e)
            Cnvrg::Logger.log_method(bind: binding)

            buffered_errors[file] = "Failed to upload #{file}: #{e.message}" if suppress_exceptions

            raise e unless suppress_exceptions
          end
          progress.progress += 1 if progress.present?

          unless buffered_errors.key?(file)
            files[file]["bv_id"]
          else
            nil
          end
        end

      blob_ids.concat blob_id_chunk
    end

    # remove nil files (failed files) from blob_ids
    blob_ids.compact!

    #save files on the server.
    resp = Cnvrg::API.request(@base_resource + "upload_files_save", 'POST', {blob_ids: blob_ids, commit: commit_sha1})
    unless Cnvrg::CLI.is_response_success(resp, false)
      raise SignalException.new("Cant save uploaded files to the server.")
    end

    return buffered_errors
  end



    def delete_files_from_server_old(files, commit_sha1)
      #files are absolute path here.
      files.each do |file|
        if file.ends_with? '/'
          #dir
          self.delete_dir(file, commit_sha1)
        else
          #file
          self.delete_file(file, commit_sha1)
        end
      end
    end

    def delete_files_from_server(files, commit_sha1, suppress_exceptions: false)
      #files are absolute path files here. ^^
      if Cnvrg::Helpers.server_version < 1
        return self.delete_files_from_server_old(files, commit_sha1)
      end
      #convert files to relative path
      files = files.map{|file| file.gsub(/^#{@project_home + "/"}/, "")}
      return if files.blank?
      resp = Cnvrg::API.request(@base_resource + "delete_files", 'DELETE', {files: files, commit: commit_sha1})
      unless Cnvrg::CLI.is_response_success(resp, false)
        raise SignalException.new("Cant delete the following files from the server.") unless suppress_exceptions
        Cnvrg::Logger.log_error_message("Cant delete the following files from the server: ")
        Cnvrg::Logger.log_error_message(files.to_s)
      end
    rescue => e
      Cnvrg::Logger.log_error_message("An exception raised in delete_files_from_server: ")
      Cnvrg::Logger.log_error(e)
      raise e unless suppress_exceptions
    end

    def upload_single_file(file)
      path = file['path']
      absolute_path = file[:absolute_path]
      @client.safe_upload(path, absolute_path)
    end

    def parse_file(file)
      abs_path = "#{@project_home}/#{file}"
      return {relative_path: file, absolute_path: abs_path} if file.ends_with? '/'
      file_name = File.basename(file)
      file_size = File.size abs_path
      mime_type = MimeMagic.by_path(abs_path)
      content_type = !(mime_type.nil? or mime_type.text?) ? mime_type.type : "text/plain"
      sha1 =  OpenSSL::Digest::SHA1.file(abs_path).hexdigest

      {relative_path: file, absolute_path: abs_path, file_name: file_name, file_size: file_size, content_type: content_type, sha1: sha1}
    rescue => e
        return false
    end

    def upload_old(absolute_path, relative_path, commit_sha1)
      if relative_path.ends_with? '/'
        self.create_dir(absolute_path, relative_path, commit_sha1)
      else
        self.upload_file(absolute_path, relative_path, commit_sha1)
      end
    end

    def upload_file(absolute_path, relative_path, commit_sha1)
      file_name = File.basename relative_path
      file_size = File.size(absolute_path).to_f
      mime_type = MimeMagic.by_path(absolute_path)
      content_type = !(mime_type.nil? or mime_type.text?) ? mime_type.type : "text/plain"
      sha1 =  OpenSSL::Digest::SHA1.file(absolute_path).hexdigest
      upload_resp = Cnvrg::API.request(@base_resource + "upload_file", 'POST_FILE', {absolute_path: absolute_path, relative_path: relative_path,
                                                                                     commit_sha1: commit_sha1, file_name: file_name,
                                                                                     file_size: file_size, file_content_type: content_type, sha1: sha1,
                                                                                      new_version:true,only_large:true})

      if Cnvrg::CLI.is_response_success(upload_resp, false)
        s3_res = upload_large_files_s3(upload_resp, absolute_path)
        return s3_res
      end
      return false

    end

    def upload_log_file(absolute_path, relative_path, log_date)
      file_name = File.basename relative_path
      file_size = File.size(absolute_path).to_f
      content_type = "text/x-log"
      upload_resp = Cnvrg::API.request("/users/#{@owner}/" + "upload_cli_log", 'POST_FILE', {absolute_path: absolute_path, relative_path: relative_path,
                                                                                             file_name: file_name, log_date: log_date,
                                                                                             file_size: file_size, file_content_type: content_type})
      path, client = upload_resp["path"], upload_resp["client"]
      @client = Cnvrg::Downloader::Client.factory(client)
      @client.upload(path, absolute_path)
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
          s3_res = upload_large_files_s3(upload_resp, absolute_path)
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
      file_name = File.basename absolute_path
      file_size = File.size(absolute_path).to_f
      content_type = MimeMagic.by_path(absolute_path)
      begin
        upload_resp = Cnvrg::API.request("images/#{image_name}/upload", 'POST_FILE', {relative_path: absolute_path,
                                                                                                  file_name: file_name,
                                                                                                  file_size: file_size,
                                                                                                  file_content_type: content_type,
                                                                                                  secret:secret
                                                                                                  })
        # puts upload_resp
        if Cnvrg::CLI.is_response_success(upload_resp, false)
          path = upload_resp["result"]["path"]
          s3_res = upload_large_files_s3(upload_resp, absolute_path)
          if s3_res
              return true
          else
            return false
          end

        end
      rescue => e
        return false
      end
        return false


    end

    def download_image(file_path_to_store, image_slug, owner)


      download_resp = Cnvrg::API.request("users/#{owner}/images/#{image_slug}/" + "download", 'GET')
      path = download_resp["result"]["path"]

      if Cnvrg::CLI.is_response_success(download_resp, false)
        begin
          open(file_path_to_store, 'wb') do |file|
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
    def download_cnvrg_image(image_name, secret)
      res =Cnvrg::API.request("images/#{image_name}/" + "download", 'POST', {secret:secret},true)
      Cnvrg::CLI.is_response_success(res, true)
      if res["result"]
        download_resp = res
        sts_path = download_resp["result"]["path_sts"]
        uri = URI.parse(sts_path)
        http_object = Net::HTTP.new(uri.host, uri.port)
        http_object.use_ssl = true if uri.scheme == 'https'
        request = Net::HTTP::Get.new(sts_path)
        body = ""
        http_object.start do |http|
          response = http.request request
          body = response.read_body
        end
        split = body.split("\n")
        key = split[0]
        iv = split[1]

        access =  Cnvrg::Helpers.decrypt(key, iv, download_resp["result"]["sts_a"])

        secret =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["sts_s"])

        session =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["sts_st"])
        region =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["region"])

        bucket =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["bucket"])
        key =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["key"])

        client = Aws::S3::Client.new(
            :access_key_id =>access,
            :secret_access_key => secret,
            :session_token => session,
            :region => region,
            :http_open_timeout => 60, :retry_limit => 20
        )

        File.open("/tmp/#{image_name}.tar", 'w+') do |file|
          resp = client.get_object({bucket:bucket,
                                    key:key}, target: file)
        end
        return true
      end

    rescue => e
      Cnvrg::Logger.log_error(e)
      return false
    end

    def resolve_bucket(response)
      begin
        sts_path = response["path_sts"]
        sts_body = self.download_and_read(sts_path)
        split = sts_body.split("\n")
        key = split[0]
        iv = split[1]
        access = Cnvrg::Helpers.decrypt(key, iv, response["sts_a"])

        secret = Cnvrg::Helpers.decrypt(key, iv, response["sts_s"])

        session = Cnvrg::Helpers.decrypt(key, iv, response["sts_st"])
        region = Cnvrg::Helpers.decrypt(key, iv, response["region"])

        bucket = Cnvrg::Helpers.decrypt(key, iv, response["bucket"])
        Cnvrg::Logger.log_info("Resolving bucket #{bucket}, region: #{region}")
        is_s3 = response["is_s3"]
        if is_s3 or is_s3.nil?
          client = Aws::S3::Client.new(
              :access_key_id => access,
              :secret_access_key => secret,
              :session_token => session,
              :region => region,
              :use_accelerate_endpoint => true,
              :http_open_timeout => 60, :retry_limit => 20)
        else
          endpoint = Cnvrg::Helpers.decrypt(key, iv, response["endpoint"])
          client = Aws::S3::Client.new(
              :access_key_id => access,
              :secret_access_key => secret,
              :region => region,
              :endpoint => endpoint, :force_path_style => true, :ssl_verify_peer => false,
              :use_accelerate_endpoint => false,
              :server_side_encryption => 'AES256',
              :http_open_timeout => 60, :retry_limit => 20)
        end

        s3 = Aws::S3::Resource.new(client: client)
        s3.bucket(bucket)
      rescue => e
        Cnvrg::Logger.log_error(e)
        Cnvrg::Logger.log_method(bind: binding)
      end
    end

    def download_and_read(path)
      body = nil
      retries = 0
      success= false
      while !success and retries < 20
        begin
          if !Helpers.is_verify_ssl
            body = open(path, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read
          else
            body = open(path).read
          end
          success = true
        rescue => e
          retries +=1
          sleep(1)
        end
      end
      body
    end

    def upload_large_files_s3(upload_resp, file_path)
      begin
        return true if upload_resp['result']['already_exists'].present?
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

          access =  Cnvrg::Helpers.decrypt(key, iv, upload_resp["result"]["sts_a"])

          secret =  Cnvrg::Helpers.decrypt(key,iv, upload_resp["result"]["sts_s"])

          session =  Cnvrg::Helpers.decrypt(key,iv, upload_resp["result"]["sts_st"])
          region =  Cnvrg::Helpers.decrypt(key,iv, upload_resp["result"]["region"])

          bucket =  Cnvrg::Helpers.decrypt(key,iv, upload_resp["result"]["bucket"])
          is_s3 = upload_resp["result"]["is_s3"]
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
                upload_file(file_path, options)

          return resp

      rescue => e
        puts e
        return false
      rescue SignalException
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
            if !Helpers.is_verify_ssl
              http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            end
            http.send_request("PUT", url.request_uri, body, {
                "content-type" => content_type,
            })
          end
          return true
        rescue Interrupt
          return false
        rescue => e
          puts e
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

      def delete_file(relative_path, commit_sha1)
        response = Cnvrg::API.request(@base_resource + "delete_file", 'DELETE', {relative_path: relative_path, commit_sha1: commit_sha1})
        return Cnvrg::CLI.is_response_success(response, false)
      end

      def delete_dir(relative_path, commit_sha1)
        response = Cnvrg::API.request(@base_resource + "delete_dir", 'DELETE', {relative_path: relative_path, commit_sha1: commit_sha1})
        return Cnvrg::CLI.is_response_success(response, false)
      end

      def create_dir(absolute_path, relative_path, commit_sha1)
        response = Cnvrg::API.request(@base_resource + "create_dir", 'POST', {absolute_path: absolute_path, relative_path: relative_path, commit_sha1: commit_sha1})
        return Cnvrg::CLI.is_response_success(response, false)
      end


    def calculate_sha1(files_list)
      files_list = files_list.map{|file| "#{@project_home}/#{file}"}
      files_list = files_list.select{|file| !file.ends_with? '/'}
      #TODO: parallel
      files_list.map do |file|
        next [file, nil] unless File.exists? file
        next [file, nil] if File.directory? file
        sha1 = OpenSSL::Digest::SHA1.file(file).hexdigest
        [file.gsub("#{@project_home}/", ""), sha1]
      end.to_h
    end


      def download_file_s3(relative_path, commit_sha1=nil, postfix: '')
        begin
          res = Cnvrg::API.request(@base_resource + "download_file", 'POST', {relative_path: relative_path,
                                                                              commit_sha1: commit_sha1,new_version:true})

          Cnvrg::CLI.is_response_success(res, false)
          if res["result"]
            download_resp = res
            filename = download_resp["result"]["filename"]
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
              puts "error in sts"
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
              endpoint = Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["endpoint"])
              client = Aws::S3::Client.new(
                  :access_key_id =>access,
                  :secret_access_key => secret,
                  :region => region,
                  :endpoint=> endpoint,:force_path_style=> true,:ssl_verify_peer=>false,
                  :http_open_timeout => 60, :retry_limit => 20)
            end
            absolute_path = "#{@project_home}/#{relative_path}#{postfix}"
            File.open(absolute_path, 'w+') do |file|
              resp = client.get_object({bucket:bucket,
                                    key:file_key}, target: file)
            end
            return true
          end

        rescue => e
          puts "error in aws"

          puts e.message
            return false

        end
      end

    def create_progressbar(length = 10, title = 'Progress')
      @progressbar = ProgressBar.create(:title => title,
                         :progress_mark => '=',
                         :format => "%b>>%i| %p%% %t",
                         :starting_at => 0,
                         :total => length,
                         :autofinish => true)
      @custom_progess = true
      @progressbar
    end

    def download_files(files, commit, postfix: '', progress: nil, threads: 15)
      return if files.blank?
      if Cnvrg::Helpers.server_version < 1
        Cnvrg::Logger.log_info("Download files from older server.")
        return self.download_files_old(files, commit, progress: progress, postfix: postfix)
      end
      res = Cnvrg::API.request(@base_resource + "download_files", 'POST', {files: files, commit: commit})
      unless Cnvrg::CLI.is_response_success(res, false)
        begin
          puts(res)
        rescue
        end
        raise StandardError.new("Cant download files from the server.")
      end
      self.download_multiple_files_s3(res['result'], @project_home, postfix: postfix, progress: progress, threads: threads)
    end


    def download_files_old(files, commit, postfix: '', progress: nil)
      files.each do |file|
        self.download_file_s3(file, commit, postfix: postfix)
        progress.progress += 1 if progress.present?
      end
    end

    def delete_files_local(deleted, conflicted: [], progress: nil)
      deleted -= conflicted
      deleted.each{|file| self.delete(file); progress.progress += 1 if progress.present?}
      conflicted.each{|file| self.delete_conflict(file); progress.progress += 1 if progress.present?}
    end

    def download_multiple_files_s3(files, project_home, postfix: '', progress: nil, threads: 15)
      cli = Cnvrg::CLI.new()
      begin
        props = {}
        client = props[:client]
        iv = props[:iv]
        key = props[:key]
        bucket = props[:bucket]
        download_succ_count = 0
        parallel_options = {
            in_threads: threads,
            isolation: true
        }

        token_mutex = Mutex.new

        Parallel.map(files["keys"], parallel_options) do |f|

          token_mutex.synchronize {
            refresh_storage_token
          }

          file_path = f["name"]
          if file_path.end_with? "/"
            # dir
            begin
              if download_dir(file_path, file_path, project_home)
                download_succ_count += 1
              else
                raise StandardError.new("Could not create directory #{file_path}.")
              end
            rescue => e
              cli.log_message("Could not create directory #{file_path}. error: #{e.message}", Thor::Shell::Color::RED)
              raise e
            end
          else
            file_path += postfix

            # blob
            begin
              if not File.exists?(project_home+"/"+File.dirname(file_path))
                FileUtils.makedirs(project_home+"/"+File.dirname(file_path))
              end
              local_path = project_home+"/"+file_path
              storage_path = f["path"]
              @client.safe_download(storage_path, local_path)
            rescue => e
              cli.log_message("Could not download file #{file_path}. error: #{e.message}", Thor::Shell::Color::RED)
              raise e
            end

            # progressbar can throw an exception so we no longer trust it!
            begin
              progress.progress += 1 if progress.present?
            rescue
              nil
            ensure
              download_succ_count += 1
            end
          end
        end
        if download_succ_count == files["keys"].size
          return Cnvrg::Result.new(true,"Done.\nDownloaded #{download_succ_count} files")
        end
      rescue => e
        cli.log_error(e)
        raise e
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

          File.open("#{project_home}/#{file_location}/#{filename}", "wb") do |file|
            file.write open(res["link"]).read
          end
        else
          return false
        end
        return true
      end

      def show_file_s3(relative_path, commit_sha1=nil)
        begin
          res = Cnvrg::API.request(@base_resource + "download_file", 'POST', { absolute_path: '', relative_path: relative_path, commit_sha1: commit_sha1, new_version:true })

          Cnvrg::CLI.is_response_success(res, false)
          if res["result"]
            download_resp = res
            filename = download_resp["result"]["filename"]

            #absolute_path += ".conflict" if conflict
            sts_path = download_resp["result"]["path_sts"]
            uri = URI.parse(sts_path)
            http_object = Net::HTTP.new(uri.host, uri.port)
            http_object.use_ssl = true if uri.scheme == 'https'
            request = Net::HTTP::Get.new(sts_path)

            body = ""
            http_object.start do |http|
              response = http.request request
              body = response.read_body
            end
            split = body.split("\n")
            key = split[0]
            iv = split[1]

            access =  Cnvrg::Helpers.decrypt(key, iv, download_resp["result"]["sts_a"])

            secret =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["sts_s"])

            session =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["sts_st"])
            region =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["region"])

            bucket =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["bucket"])
            key =  Cnvrg::Helpers.decrypt(key,iv, download_resp["result"]["key"])

            client = Aws::S3::Client.new(
                :access_key_id =>access,
                :secret_access_key => secret,
                :session_token => session,
                :region => region,
                :http_open_timeout => 60, :retry_limit => 20
            )
            resp = client.get_object({bucket:bucket,
                                    key:key})
            return resp.body.string
          end

        rescue => e
          puts e
          return false

        end
      end

      def download_dir(absolute_path, relative_path, project_home)
        FileUtils.mkdir_p("#{project_home}/#{absolute_path}")
      end

      def revoke_download_dir(absolute_path, relative_path, project_home)
        puts FileUtils.rmtree("#{absolute_path}")
      end

      def revoke_download_file(project_home, absolute_path, filename, conflict=false)
        begin
          file_location = absolute_path.gsub(/#{filename}\/?$/, "")

          filename += ".conflict" if conflict
          FileUtils.remove("#{file_location}/#{filename}")
          return true
        rescue
          return false
        end
      end
      def revoke_download(conflicted_changes,downloaded_changes)
        begin
          if !conflicted_changes.nil? and !conflicted_changes.empty?
            conflicted_changes.each do |c|
              # FileUtils.rm_rf(c+".conflict")
            end
          end
          # FileUtils.rm_rf(downloaded_changes) unless (downloaded_changes.nil? or downloaded_changes.empty?)
        rescue => e
          return false
        end

        return true

      end
    def revoke_clone(project_home)
      begin
        FileUtils.rm_rf(project_home)
      rescue
      end

    end

    def delete_commit_files_local(deleted)
      begin
        FileUtils.rm_rf(deleted) unless (deleted.nil? or deleted.empty?)
        return true
      rescue => e
        return false
      end
    end

    def start_commit(new_branch,force:false, exp_start_commit:nil, job_slug: nil, job_type: nil, start_commit: nil, message: nil, debug_mode: false)
        response = Cnvrg::API.request(
            "#{base_resource}/commit/start",
            'POST',
            {
                project_slug: @project_slug, username: @owner,
                new_branch: new_branch, force:force,
                exp_start_commit:exp_start_commit, start_commit: start_commit,
                job_slug: job_slug, job_type: job_type, message: message,
                debug_mode: debug_mode
            }
        )

        Cnvrg::CLI.is_response_success(response,false)
        return response
      end

    def end_commit(commit_sha1,force:false,message:"")
      response = Cnvrg::API.request("#{base_resource}/commit/end", 'POST', {commit_sha1: commit_sha1,force:force,message:message})
      return response
    end

    def download_file(file_path: '', key: '', iv: '', bucket: '', path: '', client: nil)
      local_path = @project_home+"/"+file_path
      @client.safe_download(path, local_path)
    end

    def delete(file)
      file = "#{@project_home}/#{file}" unless File.exists? file
      return unless File.exists? file
      FileUtils.rm_rf(file)
    end

    def delete_conflict(file)
      file = "#{@project_home}/#{file}" unless File.exists? file
      return unless File.exists? file
      File.rename(file, "#{file}.deleted")
    end

    def handle_compare_idx(compared, resolver: {})
      begin
        all_files = compared.values.flatten.uniq
        props = {}
        files = resolver['keys'].map{|f| [f['name'], f]}.to_h
        client = props[:client]
        iv = props[:iv]
        key = props[:key]
        bucket = props[:bucket]
        parallel_options = {
            :progress => {
                :title => "Jump Progress",
                :progress_mark => '=',
                :format => "%b>>%i| %p%% %t",
                :starting_at => 0,
                :total => all_files.size,
                :autofinish => true
            },
            in_processes: Cnvrg::CLI::ParallelProcesses,
            in_thread: Cnvrg::CLI::ParallelThreads
        }
        Parallel.map(all_files, parallel_options) do |file|
          Cnvrg::CLI.log_message("Trying #{file}")
          if compared['conflicts'].include? file
            self.download_file(file_path: "#{file}.conflict", key: key, iv: iv, bucket: bucket, path: files[file]['path'], client: client)
            next
          end
          if compared['updated_on_server'].include? file
            self.download_file(file_path: file, key: key, iv: iv, bucket: bucket, path: files[file]['path'], client: client)
            next
          end
          if compared['deleted'].include? file
            self.delete(file)
            next
          end
          Cnvrg::CLI.log_message("Failed #{file}")
        end
      rescue => e
        Cnvrg::Logger.log_error(e)
        raise SignalException.new("Cant upload files")
      end
    end
      def rollback_commit(commit_sha1)
        response = Cnvrg::API.request("#{base_resource}/commit/rollback", 'POST', {commit_sha1: commit_sha1})
        Cnvrg::CLI.is_response_success(response, false)
      end
    private
    def log(msgs, type: Thor::Shell::Color::GREEN)
      return false if @cli.blank?
      msgs = [msgs].flatten
      msgs.each do |msg|
        @cli.log_message(msg, type)
      end
    end


    def log_error(msgs)
      @cli.log_error(msgs) if @cli.present?
      log(msgs, type: Thor::Shell::Color::RED)
    end

    def log_progress(msgs)
      log(msgs, type: Thor::Shell::Color::BLUE)
    end
  end


  end
