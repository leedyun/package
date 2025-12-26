require 'fileutils'
require 'cnvrg/files'
require 'mimemagic'


module Cnvrg
  class Images
    # attr_reader :image_name, :image_tag, :is_docker, :project_slug, :commit_id, :owner, :port, :image_slug


    def initialize()
      begin
        home_dir = File.expand_path('~')
        config = YAML.load_file(home_dir+"/.cnvrg/config.yml")
        @owner = config.to_h[:owner]
        @username =  config.to_h[:username]
      rescue => e
        @owner = ""
        @username =  ""
        Cnvrg::Logger.log_info("cnvrg is not configured")
      end

    end

    def upload_docker_image(image_path, image_name,workdir, user, description, is_gpu )
      begin
      if image_name.present? and image_name.include? ":"
        image_split = image_name.split(":")
        image_name = image_split[0]
        image_tag = image_split[1]
        if image_tag.blank?
          image_tag = "latest"
        end
        if image_name.blank?
          Cnvrg::Logger.log_info("image_name: #{image_name} is not valid")
          return false
        end
      end
      if !File.exist? image_path
        Cnvrg::Logger.log_info("image_path: #{image_path} was not found")
        return false
      end
      is_dockerfile = (!image_path.end_with? ".tar") ? true : false
      file_name = File.basename image_path
      file_size = File.size(image_path).to_f
      mime_type = MimeMagic.by_path(image_path)
      content_type = mime_type.present? ? mime_type.type : "application/x-tar"

      image_res = Cnvrg::API.request("users/#{@owner}/images/upload" , 'POST_FILE', {image_name: image_name, image_tag: image_tag,
                                                                                workdir: workdir, user: user, description:description, is_gpu:is_gpu,
                                                                                file_name: file_name,relative_path:image_path,
                                                                                file_size: file_size, file_content_type: content_type, is_dockerfile: is_dockerfile
                                                                                 })

      Cnvrg::CLI.is_response_success(image_res, true)

      path = image_res["result"]["path"]
      image_id = image_res["result"]["image_id"]

      props = Cnvrg::Helpers.get_s3_props(image_res["result"])
      if props.is_a? Cnvrg::Result
        return false
      end

      client = props[:client]
      upload_options = props[:upload_options]
      bucket = Aws::S3::Resource.new(client: client).bucket(props[:bucket])
      resp = bucket.object(path).
          upload_file(image_path, upload_options)
      unless resp
        raise Exception.new("Cant upload #{image_path}")
        return false
      end
      return save_docker_image(image_id)
      rescue => e
        Cnvrg::Logger.log_error(e)

        return false
      end



    end

    def save_docker_image(image_id)
      image_res = Cnvrg::API.request("users/#{@owner}/images/#{image_id}/save" , 'POST', {})
       Cnvrg::CLI.is_response_success(image_res, true)
      return image_res
    end

    def is_container_exist()
      config = YAML.load_file(@working_dir+"/.cnvrg/config.yml")
      if config[:container].nil?
        return false
      end
      return config[:container]
    end

    def container_port()
      config = YAML.load_file(@working_dir+"/.cnvrg/config.yml")
      if config[:container].nil?
        return false
      else
        return config[:port]
      end
    end

    def self.image_exist(owner, image_name)

      image_res = Cnvrg::API.request("users/#{owner}/images/" + "find", 'POST', {image_name: image_name})

      if Cnvrg::CLI.is_response_success(image_res)
        image= image_res["result"]["image"]
        return image
      else
        return false

      end
    end
    def store_image_build_commands(working_dir, cmd)
      begin
      custom_image_file = working_dir+"/.cnvrg/custom_image.txt"
      if !File.exist? custom_image_file
        FileUtils.touch [custom_image_file]
      end
      File.open(custom_image_file, 'a' ) do  |f|
        f.puts cmd
      end
      rescue
      end


    end
    def self.create_new_custom_image(type,owner,image_name,is_public,is_base,image_extend,python3,tar_path)
       response = Cnvrg::API.request("users/#{owner}/images/custom", 'POST', {instance_type:type,image_name:image_name,is_public:is_public,
                                                                                is_base:is_base,image_extend:image_extend,
                                                                                python3:python3})

      return response
    end
    def self.create_new_custom_image_with_docker(type,owner,image_name,is_public,is_base,image_extend,python3,tar_path,files)
        file_name = File.basename tar_path
        file_size = File.size(tar_path).to_f
        mime_type = MimeMagic.by_path(tar_path)
        content_type = !(mime_type.nil? or mime_type.text?) ? mime_type.type : "text/plain"

        upload_resp = Cnvrg::API.request("/users/#{owner}/images/upload_docker", 'POST_FILE', {absolute_path: tar_path, relative_path: tar_path,
                                                                                        file_name: file_name, file_size: file_size,
                                                                                        file_content_type: content_type,
                                                                                        image_name:image_name,is_public:is_public,
                                                                                        is_base:is_base,image_extend:image_extend,
                                                                                        python3:python3 })

        if Cnvrg::CLI.is_response_success(upload_resp, false)
          path = upload_resp["result"]["path"]

          s3_res = files.upload_small_files_s3(path, tar_path, content_type)
          if s3_res
            image_slug = upload_resp["result"]["id"]
            response = Cnvrg::API.request("users/#{owner}/images/#{image_slug}/build", 'POST', {instance_type:type,image_extend:image_extend})
          end
        end

    end



    def self.revoke_custom_new_image(owner,slug)
      response = Cnvrg::API.request("users/#{owner}/images/#{slug}/revoke_image", 'GET')
      return response
    end
    def self.commit_custom_image(owner,slug,logs)
      response = Cnvrg::API.request("users/#{owner}/images/#{slug}/commit_custom_image", 'POST', {image_logs:logs})
      return response
    end


    def create_custom_image(new_image_name,working_dir,stored_commands)

      python2_arr = get_installed_packages("python2")
      py2 = python2_arr.join(",") unless python2_arr.nil? or python2_arr.empty?
      python3_arr = get_installed_packages("python3")
      py3 = python3_arr.join(",") unless python3_arr.nil? or python3_arr.empty?
      system_arr = get_installed_packages("system")
      sys = system_arr.join(",") unless system_arr.nil? or system_arr.empty?

      response = Cnvrg::API.request("users/#{@owner}/projects/#{@project_slug}/images/push", 'POST', {image_slug: @image_slug, py2: py2,py3:py3,
                                                                                             dpkg: sys, new_image_name: new_image_name,
                                                                                             run_commands:stored_commands})
      if Cnvrg::CLI.is_response_success(response) and !response["result"]["slug"].nil?
        container = get_container()
        name = response["result"]["name"]
        container = get_container()
        container.commit({repo:name,tag:"latest"})
        update_image(name+":latest", container, response["result"]["slug"])
        File.truncate(working_dir+"/.cnvrg/custom_image.txt", 0)

      end

      return true

    end

    def update_image(image_name, container, image_slug)
      config = YAML.load_file(@working_dir+"/.cnvrg/config.yml")
      @image_name = image_name
      if !@image_name.nil? and !@image_name.empty?
        @image_name = image_name[0, image_name.index(":")]
        @image_tag = image_name[image_name.index(":")+1, image_name.size]
      end
      config = {project_name: config[:project_name],
                project_slug: config[:project_slug],
                owner: config[:owner],
                docker: true, image_base: @image_name, image_tag: @image_tag, container: container.id, image_slug: image_slug}

      File.open(@working_dir+"/.cnvrg/config.yml", "w+") { |f| f.write config.to_yaml }
    end

    def save_installed_libraries(container)
      begin
        command = ['/bin/bash', '-lc', '/opt/ds/bin/pip freeze']
        pip = container.exec(command, tty: true)[0]
        command = ["/bin/bash", "-lc", "dpkg -l | grep '^ii' | awk '{print $2\"==\"$3}'"]
        dpkg = container.exec(command, tty: true)[0]
        File.open(@working_dir+"/.cnvrg/pip_base.txt", "w+") { |f| f.write pip }
        File.open(@working_dir+"/.cnvrg/dpkg_base.txt", "w+") { |f| f.write dpkg }
      rescue => e
      end


    end

    def remote_notebook(notebook_path, instance_type, kernel,data,data_commit)
      response = Cnvrg::API.request("users/#{@owner}/images/#{@image_slug}/remote_notebook", 'POST', {dir: notebook_path,
                                                                                                      project_slug: @project_slug,
                                                                                                      instance_type: instance_type,
                                                                                                      kernel: kernel,
                                                                                                      dataset_slug:data,
                                                                                                      dataset_commit: data_commit})
      return response
    end

    def get_installed_packages(repo)
      container = get_container()
      case repo
        when "python2"
          command = ['/bin/bash', '-lc', '/opt/ds/bin/pip freeze']
        when "python3"
          command = ['/bin/bash', '-lc', '/opt/ds3/bin/pip3 freeze']
        when "system"
          command = ["/bin/bash", "-lc", "dpkg -l | grep '^ii' | awk '{print $2\"==\"$3}'"]
      end

      libs = container.exec(command, tty: true)[0]
      libs_arr = libs.join("").split("\r\n")
      return libs_arr

    end

    def get_bash_history
      container = get_container()
      command = ["/bin/bash", "-lc", "cat /home/ds/.bash_history"]
      history = container.exec(command, tty: true)[0][0]
      if history.include? "No such file"
        history = ""
      end
      return history
    end


    def get_image_state
      python_arr = self.get_installed_packages("python")
      py = python_arr.join(",") unless python_arr.nil? or python_arr.empty?
      system_arr = self.get_installed_packages("system")
      sys = system_arr.join(",") unless system_arr.nil? or system_arr.empty?
      # bash_history = self.get_bash_history
      diff = [py, sys]

    end

    def find_image(update=true)
      config = YAML.load_file(@working_dir+"/.cnvrg/config.yml")
      image_slug = config[:image_slug]
      if image_slug.nil? or image_slug.empty?
        image_res = Cnvrg::API.request("users/#{@owner}/images/" + "find", 'POST', {image_name: @image_name})

        if Cnvrg::CLI.is_response_success(image_res)
          image_slug = image_res["result"]["image"]["slug"]
          update_slug(image_slug) unless !update
          return image_slug
        end
      else
        return image_slug

      end
    end

    def set_note_url(note_slug)
      config = YAML.load_file(@working_dir+"/.cnvrg/config.yml")
      config[:notebook_slug] = note_slug
      File.open(@working_dir+"/.cnvrg/config.yml", "w+") { |f| f.write config.to_yaml }
    end
    def note_slug
      config = YAML.load_file(@working_dir+"/.cnvrg/config.yml")
      note_slug = config[:notebook_slug]
      if note_slug.nil? or note_slug.empty?
        return false
      else
        return note_slug
      end
    end
    def remove_note_slug
      config = YAML.load_file(@working_dir+"/.cnvrg/config.yml")
      config[:notebook_slug] = ""
      File.open(@working_dir+"/.cnvrg/config.yml", "w+") { |f| f.write config.to_yaml }

    end


    def update_slug(slug)
      config = YAML.load_file(@working_dir+"/.cnvrg/config.yml")
      config[:image_slug] = slug
      File.open(@working_dir+"/.cnvrg/config.yml", "w+") { |f| f.write config.to_yaml }
    end

    def new_machine(instance_type)
      title = "#{instance_type} auto created by cli"
      response = Cnvrg::API.request("users/#{@owner}/machines/new", 'POST', {machine_name: title, instance_type: instance_type})
      return Cnvrg::CLI.is_response_success(response)

    end

    def update_image_activity(commit, exp_slug)
      response = Cnvrg::API.request("users/#{@owner}/images/#{@image_slug}/update_activity", 'POST', {commit: commit, project_slug: @project_slug, experiment: exp_slug})
      return Cnvrg::CLI.is_response_success(response)
    end

    def handle_image_activity
      home_dir = File.expand_path('~')
      zip_dir = "#{home_dir}/.cnvrg/tmp/config.zip"
      compress = `zip -j #{zip_dir} #{home_dir}/.netrc #{home_dir}/.cnvrg/config.yml`
      @files = Cnvrg::Files.new(@owner, @project_slug)
      res_id = @files.upload_exec_file(zip_dir, @image_name, @commit_id)
      FileUtils.remove zip_dir
      return res_id
    end


  end

end
