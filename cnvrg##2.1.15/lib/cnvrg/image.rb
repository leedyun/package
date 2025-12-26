module Cnvrg
  class Image
    # attr_reader :image_name, :image_tag, :is_docker, :project_slug, :commit_id, :owner, :port, :image_slug


    def initialize(image_id)
      begin
        @cli = Cnvrg::CLI.new
        home_dir = File.expand_path('~')
        config = YAML.load_file(home_dir+"/.cnvrg/config.yml")
        @owner = config.to_h[:owner]
        @username =  config.to_h[:username]
        @image_id = image_id
      rescue => e
        @owner = ""
        @username =  ""
        @cli.log_message("cnvrg is not configured")
      end
    end

    def build
      image_data = get_image_data
      file_name = "Dockerfile-#{@image_id}"
      File.new(file_name, "w+")
      if image_data["reqs_file_path"].present? and image_data["from_image_name"]
        File.open(file_name, "w+") do |i|
          i.write("FROM #{image_data["from_image_name"]}")
          i.write("ADD requirements.txt requirements.txt")
          i.write("RUN pip3 install -r requirements.txt")
        end
      else
        open(file_name, 'wb') do |file|
          file << open(image_data["docker_file_path"]).read
        end
      end
        docker_url = "#{image_data["docker_name"]}"
        command = {:type=>"notify",
                   :title=>"docker build",
                   :logs=>true,
                  :before_execute_log=>"Building docker image",
                  :timeout=>3600,
                   :command=>"sudo docker build . -t #{docker_url} -f #{file_name}"}
      @executer = Helpers::Executer.new(project: @project, job_type: "image", job_id: @image_id, image: self)
      exit_status, output, errors, _, _ = @executer.execute(command)
      all_logs = join_logs(output, errors)
      if exit_status != 0
        raise StandardError.new(all_logs)
      end
      if ENV["CNVRG_IMAGE_BUILD_USERNAME"].present? and ENV["CNVRG_IMAGE_BUILD_PASSWORD"].present?
        if ENV["CNVRG_IMAGE_BUILD_REGISTRY"].present?
        command = {:type=>"notify",
                    :no_stdout => true,
                    :title=>"docker login",
                    :logs=>true,
                    :command=>"sudo docker login #{ENV["CNVRG_IMAGE_BUILD_REGISTRY"]} --username=#{ENV["CNVRG_IMAGE_BUILD_USERNAME"]} --password=\"#{ENV["CNVRG_IMAGE_BUILD_PASSWORD"]}\""}
        else
          command = {:type=>"notify",
                     :no_stdout => true,
                     :title=>"docker login",
                     :logs=>true,
                     :command=>"sudo docker login --username=#{ENV["CNVRG_IMAGE_BUILD_USERNAME"]} --password=\"#{ENV["CNVRG_IMAGE_BUILD_PASSWORD"]}\""}
          end
        exit_status, output, errors, _, _ = @executer.execute(command)
        all_logs = join_logs(output, errors)
        if exit_status != 0
          raise StandardError.new(all_logs)
        end
      end
      command = {:type=>"notify",
                  :title=>"docker push",
                  :logs=>true,
                 :before_execute_log=>"Pushing docker image",
                 :timeout=>3600,
                 :command=>"sudo docker push #{docker_url}"}
      exit_status, output, errors, _, _ = @executer.execute(command)
      all_logs = join_logs(output, errors)
      if exit_status != 0
        raise StandardError.new(all_logs)
      end
      post_build_update(true)
    rescue => e
      @cli.log_message("Image Build failed")
      post_build_update(false, e.message)
    end

    def get_image_data
      response = Cnvrg::API.request("users/#{@owner}/images/#{@image_id}/image_start_build", 'GET')
      CLI.is_response_success(response)
      return response["image"]
    end

    def post_build_update(success, message = "")
      response = Cnvrg::API.request("users/#{@owner}/images/#{@image_id}/image_end_build", 'POST', {success: success, message: message})
      CLI.is_response_success(response)
      return response["image"]
    end


    def job_log(logs, level: 'info', step: nil, job_type: "image", job_id: @image_id)
      logs = [logs].flatten
      logs.each_slice(10).each do |temp_logs|
        Cnvrg::API.request("users/#{@owner}/images/#{@image_id}/log", "POST", {job_type: job_type, job_id: job_id, logs: temp_logs, log_level: level, step: step, timestamp: Time.now})
        sleep(1)
      end
    end


    def join_logs(output, errors)
      output.map{ |o| o[:logs]}.join(" ") + " " + errors.map{ |o| o[:logs]}.join(" ")
    end

  end
end
