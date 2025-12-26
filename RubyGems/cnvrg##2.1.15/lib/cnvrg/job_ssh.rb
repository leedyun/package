module Cnvrg
  class JobSsh < SubCommandBase

    desc 'ssh start', 'stats of agent and slave'
    method_option :port, :type => :numeric, :aliases => ["-p", "--port"], :desc => "Port to bind into", :default => 2222
    method_option :username, :type => :string, :aliases => ["-u", "--username"], :desc => "Job container user name", :default => nil
    method_option :password, :type => :string, :aliases => ["--password"], :desc =>"Job Conatainer user name, will be set by cnvrg", :default => nil
    method_option :no_auth, :type => :boolean, :aliases => ["--no-auth"], :default => false
    method_option :internal_port, :type => :numeric, :aliases => ["--internal-port"], :desc =>"Internal port in the pod for the ssh", :default => 22
    method_option :kubeconfig, :type => :string, :aliases => ["--kubeconfig"], :desc => "Path to kubeconfig, if blank default config will be used", :default => nil
    def start(job_id)
      no_auth = options["no_auth"]
      Cnvrg::CLI.new.log_start(__method__, args, options)
      @job_ssh = ConnectJobSsh.new(job_id)
      @job_ssh.start(options['username'], options['password'], no_auth, port: options['internal_port'])
      pod_name = nil
      namespace = "cnvrg"
      ssh_ready = false
      internal_port = options['internal_port']
      while not ssh_ready
        resp = @job_ssh.status()
        status = resp["ssh_status"]

        if status == "in_progress"
            puts("Waiting for ssh to start ...")
            sleep(3)
            next
        elsif status == "finished"
            password = resp["password"]
            username = resp["username"]
            pod_name = resp["pod_name"]
            namespace = resp["namespace"]
            internal_port = resp["port"] || internal_port
            ssh_ready = true
        else
          puts("Failed to start ssh")
          break
        end 
      end
      if pod_name.blank? or (password.blank? and !no_auth) or username.blank?
        puts("Failed to get required params")
        return
      end

      puts("In order to connect to your job, define your ssh connection with the following params:")
      puts("host: 127.0.0.1")
      puts("port: #{options["port"]}")
      puts("username: #{username}")
      puts("password: #{password}") unless no_auth
      @job_ssh.run_portforward_command(pod_name, options["port"], options["kubeconfig"], namespace, internal_port)
    end
  end
end