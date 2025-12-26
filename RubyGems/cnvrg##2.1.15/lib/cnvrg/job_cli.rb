module Cnvrg
    class JobCli < SubCommandBase

        desc 'log', '', :hide => true
        method_option :level, :type => :string, :aliases => ["-l", "--level"], :default => 'info'
        method_option :step, :type => :string, :aliases => ["-s", "--step"], :default => nil
        method_option :restart, :type => :boolean, :aliases => ["-r", "--restart"], :default => false
        def log(*logs)
            Cnvrg::CLI.new.log_start(__method__, args, options)
            @project = Project.new(owner: ENV['CNVRG_OWNER'], slug: ENV['CNVRG_PROJECT'])
            if options['restart'] == @project.check_job_pod_restart[0] or options['step'] == "ready"
                @project.job_log(logs, level: options['level'], step: options['step'])
            else
                @project.job_log(nil, level: options['level'], step: options['step'])
            end
        end

        desc 'requirements', '', :hide => true
        def requirements
          cli = Cnvrg::CLI.new
          cli.log_start(__method__, args, options)
          project_dir = cli.get_project_home
          @project = Project.new(project_dir, owner: ENV['CNVRG_OWNER'], slug: ENV['CNVRG_PROJECT'])
        end

        desc 'install_reqs', 'Install requirements', :hide => true
        def install_reqs
            cli = Cnvrg::CLI.new
            cli.log_start(__method__, args, options)
            @project = Project.new(nil, owner: ENV['CNVRG_OWNER'], slug: ENV['CNVRG_PROJECT'])
            @executer = Helpers::Executer.new(project: @project, job_type: ENV['CNVRG_JOB_TYPE'], job_id: ENV['CNVRG_JOB_ID'])
            commands = @executer.get_requirements_commands
            @executer.execute_cmds(commands)
        end

        desc 'start', 'Job Start!', :hide => true
        def start
            cli = Cnvrg::CLI.new
            cli.log_start(__method__, args, options)
            cli.auth
            poll_every = (ENV["CNVRG_AGENT_POLL_EVERY"] || '30').to_i
            owner = ENV["CNVRG_OWNER"]
            machine_activity_slug = ENV["CNVRG_MACHINE_ACTIVITY"]
            job_id = ENV["CNVRG_JOB_ID"]
            @executer = Cnvrg::Helpers::Executer.new(machine_activity: machine_activity_slug, poll_every: poll_every, owner: owner, job_id: job_id)
            @executer.main_thread
        end

        desc 'stats', 'stats of agent and slave', :hide => true
        def stats
            cli = Cnvrg::CLI.new
            cli.log_start(__method__, args, options)
            poll_every = (ENV["CNVRG_AGENT_POLL_EVERY"] || '30').to_i
            owner = ENV["CNVRG_OWNER"]
            machine_activity_slug = ENV["CNVRG_MACHINE_ACTIVITY"]
            job_id = ENV["CNVRG_JOB_ID"]
            @executer = Cnvrg::Helpers::Executer.new(machine_activity: machine_activity_slug, poll_every: poll_every, owner: owner, job_id: job_id)
            @executer.executer_stats
        end

        desc 'pre_pod_stop', '', :hide => true
        def pre_pod_stop
            cli = Cnvrg::CLI.new
            cli.log_start(__method__, args, options)
            owner = ENV["CNVRG_OWNER"]
            machine_activity = YAML.load_file("/conf/.machine_activity.yml") rescue {:slug => ENV["CNVRG_MACHINE_ACTIVITY"]}
            machine_activity_slug = machine_activity[:slug]
            job_id = ENV["CNVRG_JOB_ID"]
            @executer = Cnvrg::Helpers::Executer.new(machine_activity: machine_activity_slug, owner: owner, job_id: job_id)
            @executer.pre_pod_stop
        end
    end
end