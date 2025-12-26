module Cnvrg
  class ConnectJobSsh
    def initialize(job_id)
      home_dir = File.expand_path('~')
      config = YAML.load_file(home_dir+"/.cnvrg/config.yml")
      @owner = config.to_h[:owner]
      @job_id = job_id
    rescue => e
      @owner = ""
      Cnvrg::Logger.log_info("cnvrg is not configured")
    end

    def start(username, password, no_auth, port: nil)
      Cnvrg::API_V2.request("#{@owner}/job_ssh/#{@job_id}/start" , 'POST', {username: username, password: password, no_auth: no_auth, port: port})
    end

    def status()
      Cnvrg::API_V2.request("#{@owner}/job_ssh/#{@job_id}/status" , 'GET', nil)
    end

    def run_portforward_command(pod_name, port, kubeconfig, namespace, internal_port)
      command = "kubectl"
      if kubeconfig.present?
        command = "kubectl --kubeconfig=#{kubeconfig}"
      end
      bashCommand = "#{command} -n #{namespace} port-forward #{pod_name} #{port}:#{internal_port}"
      puts("\nrunning command #{bashCommand}")
      `#{bashCommand}`
    end
  end
end