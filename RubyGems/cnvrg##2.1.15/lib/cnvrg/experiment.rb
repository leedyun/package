require 'net/http'
module Cnvrg
  class Experiment
    attr_reader :slug
    attr_reader :sync_before_terminate
    attr_reader :sync_delay_time
    attr_reader :output_dir

    def initialize(owner, project_slug, job_id: nil)
      @project_slug = project_slug
      @owner = owner
      @command = nil
      @base_resource = "users/#{owner}/projects/#{project_slug}/"
      @slug = job_id
      @sync_before_terminate = nil
      @sync_delay_time = nil
      @output_dir = nil
    end

    def as_env
      return {
          CNVRG_JOB_ID: @slug,
          CNVRG_JOB_TYPE: "Experiment",
          CNVRG_PROJECT: @project_slug,
          CNVRG_OWNER: @owner,
      }.as_json
    end

    def start(input, platform, machine_name, start_commit, name, email_notification, machine_activity,script_path,
              sync_before_terminate, periodic_sync)

      res = Cnvrg::API.request(@base_resource + "experiment/start", 'POST',
                               {input: input, platform: platform, machine_name: machine_name, start_commit: start_commit,
                                title: name, email_notification: email_notification, machine_activity: machine_activity,script_path:script_path})
      Cnvrg::CLI.is_response_success(res,false)

      @slug = res.to_h["result"].to_h["slug"]
      @sync_before_terminate = res.to_h["result"].to_h["sync_before_terminate"]
      @sync_delay_time = res.to_h["result"].to_h["sync_delay_time"]
      @output_dir = res.to_h["result"].to_h["output_dir"]
      @command = res.to_h["result"].to_h["command"] rescue nil

      return res

    end

    def start_notebook_session(kernel, start_commit, token, port, remote, notebook_path)
      res = Cnvrg::API.request(@base_resource + "notebook/start_session", 'POST',
                               {kernel: kernel, start_commit: start_commit,
                                 token: token, port: port, remote: remote, notebook_path: notebook_path})
      Cnvrg::CLI.is_response_success(res)

      @slug = res["result"]["id"]


      return @slug

    end

    def end_notebook_session(notebook_slug)
      res = Cnvrg::API.request(@base_resource + "notebook/#{notebook_slug}/stop", 'GET')
      Cnvrg::CLI.is_response_success(res,false)

      return res

    end
    def update_notebook_slug(proj_dir, slug)
      begin
      file = proj_dir+"/.cnvrg/notebook_slug"
      FileUtils.touch file

      File.open(file, "w+") { |f| f.write slug }
      rescue
      end

    end

    def get_notebook_slug(proj_dir)
      begin
        notebook_slug = File.open(proj_dir + "/.cnvrg/notebook_slug", "rb").read
        notebook_slug = notebook_slug.gsub("/n", "")
        notebook_slug = notebook_slug.to_s.strip
        return notebook_slug
      rescue
        return nil
      end


    end
    def get_machine_activity(working_dir)
      begin
        machine_activity = File.open("#{working_dir}/.cnvrg/machine_activity", "rb").read
        machine_activity = machine_activity.to_s.strip
        ma_id = machine_activity.to_i
        return ma_id
      rescue
        return nil
      end


    end

    def job_log(logs, level: 'info', step: nil, job_type: nil, job_id: nil)
      logs = [logs].flatten
      logs.each_slice(10).each do |temp_logs|
        Cnvrg::API.request("users/#{@owner}/projects/#{@project_slug}/jobs/experiment/#{@slug}/log", "POST", {job_type: "Experiment", job_id: @slug, logs: temp_logs, log_level: level, step: step, timestamp: Time.now})
        sleep(1)
      end
    end

    def exec_remote(command, commit_to_run, instance_type, image_slug,schedule,local_timestamp, grid,path_to_cmd,data, data_commit,periodic_sync,
                    sync_before_terminate, max_time, ds_sync_options=0,output_dir=nil,data_query=nil,
                    git_commit=nil, git_branch=nil,debug=true, restart_if_stuck=nil, local_folders=nil,title=nil, datasets=nil, prerun: true, requirements: true, recurring: nil,
                    email_notification_error: false, email_notification_success: false, emails_to_notify: nil)
      response = Cnvrg::API.request("users/#{@owner}/projects/#{@project_slug}/experiment/remote", 'POST', {command: command, image_slug: image_slug,
                                                                                                            commit_sha1: commit_to_run,
                                                                                                            instance_type: instance_type,
                                                                                                            schedule:schedule,
                                                                                                            local_timestamp:local_timestamp,
                                                                                                            datasets: datasets,
                                                                                                            grid: grid,
                                                                                                            debug:debug,
                                                                                                            path_to_cmd:path_to_cmd,dataset_slug:data,
                                                                                                            dataset_commit: data_commit,max_time:max_time,
                                                                                                            periodic_sync:periodic_sync, sync_before_terminate:sync_before_terminate,
                                                                                                            dataset_sync_options:ds_sync_options,output_dir:output_dir,
                                                                                                            dataset_query:data_query,git_commit:git_commit,git_branch:git_branch,
                                                                                                            restart_if_stuck:restart_if_stuck, local_folders: local_folders, title:title,
                                                                                                            prerun: prerun, requirements: requirements, recurring: recurring,
                                                                                                            email_notification_error: email_notification_error, email_notification_success: email_notification_success,
                                                                                                            emails_to_notify: emails_to_notify})

      return response
    end
    def remote_notebook(instance_type, commit, data, data_commit, notebook_type,ds_sync_options=0,data_query=nil, image = nil, datasets = nil)
      response = Cnvrg::API.request("users/#{@owner}/projects/#{@project_slug}/notebook/remote", 'POST', { instance_type: instance_type, dataset_slug:data,
                                                                                                           dataset_commit: data_commit, image_slug:image,
                                                                                                           datasets: datasets,
                                                                                                           commit:commit, notebook_type:notebook_type, dataset_sync_options:ds_sync_options,
                                                                                                           dataset_query: data_query })
      return response
    end

    def upload_temp_log(temp_log)
      response = Cnvrg::API.request(@base_resource + "experiment/upload_temp_log", 'POST', { output: temp_log,
                                                                                             exp_slug: @slug })
      Cnvrg::CLI.is_response_success(response, false)
    end

    def send_machine_stats(stats)
      response = Cnvrg::API.request(
        @base_resource + "experiment/upload_stats",
        "POST",
        {
          exp_slug: @slug,
          stats: stats.map { |s| s.merge!({ time: Time.now }) }
        }
      )
      Cnvrg::CLI.is_response_success(response, false)
    end

    def end(output, exit_status, end_commit, cpu_average, memory_average, end_time: nil)
      #if remote try to remove
      tries = 0
      success = false
      end_time ||= Time.now
      while tries < 10 and success.blank?
        sleep (tries * rand) ** 2 ### exponential backoff
                                ## this call is super important so we cant let it crash.

        tries += 1
        response = Cnvrg::API.request(@base_resource + "experiment/end", 'POST', {output: output, exp_slug: @slug,
                                                                                exit_status: exit_status, end_commit: end_commit,
                                                                                cpu_average: cpu_average, memory_average: memory_average, end_time: end_time})
        success = Cnvrg::CLI.is_response_success(response,false)
      end

      begin
        FileUtils.rm_rf(["/home/ds/.cnvrg/tmp/exec.log"])
      rescue

      end
    end

    def get_cmd
      return @command
    end

    def restart_spot_instance

      restart = false
      begin
      url = URI.parse('http://169.254.169.254/latest/meta-data/spot/termination-time')
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      unless res.body.include? "404"
        restart = true
      end
      if res.body.include? "Empty reply from server"
        restart = false
      end
      rescue
        restart = false

      end

      return restart

    end

    def send_restart_request(sha1=nil)
      Cnvrg::API.request(@base_resource + "experiment/check_spot_instance", 'POST', {exp_slug: @slug, end_commit: sha1})
    end
  end
end
