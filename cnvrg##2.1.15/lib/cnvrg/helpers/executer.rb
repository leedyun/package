require "filewatch/tail"
require 'cnvrg/helpers/agent'
class Cnvrg::Helpers::Executer
  attr_reader :machine_activity, :agent_id, :main_id
  MAIN_CONTAINER_PORT = ENV['MAIN_CONTAINER_PORT'].try(:to_i) || 4000
  HAS_DOCKER = ENV['HAS_DOCKER'] == "true"

  ### this class represent a machine_activity. it will poll the commands, communicate with the
  # server (poll commands) and let the server know the status of this executer.
  def initialize(owner: nil, machine_activity: nil, poll_every: 30, job_id: nil)
    @owner = owner
    @job_id = job_id
    @poll_every = poll_every
    @check_main_every = 10
    @machine_activity = machine_activity
    @commands_q = Queue.new
    @files_q = Queue.new
    @agent_id = nil
    @main_id = nil
    @main_start_time = nil
    @is_new_main = !ENV["MAIN_CONTAINER_PORT"].blank?
    @main_name = @is_new_main ? "main" : "slave"
  end

  def create_file_cmd(path, content)
    if path.include? "~"
      path = File.expand_path(path)
    end
    FileUtils.mkdir_p(File.dirname(path))
    File.open(path, "w+"){|f| f.write(content)}
  end

  def handle_files(files)
    (files || {}).each do |path, content|
      create_file_cmd(path, content)
    end
  end

  def activity_url
    ['users', @owner, 'machine_activities', @machine_activity].join("/")
  end

  def executer_stats
    return @stats if @stats.present?
    Cnvrg::Logger.log_info("getting containers")
    @agent_id, @main_id = containers
    Cnvrg::Logger.log_info("got containers")
    pod_name, node_name = get_node_and_pod_names
    # For backwards compatibility we still call this slave stats
    @stats = {
        pod_name: pod_name,
        node_name: node_name,
        agent: {
          container_id: @agent_id,
          workdir: `pwd`.strip,
          homedir: current_homedir,
          user: `whoami`.strip,
          user_id: `id -u`.strip,
          group_id: `id -g`.strip,
          cnvrg: Cnvrg::VERSION
        },
        slave: {
            container_id: @main_id,
            container_name: @main_name,
            workdir: run_in_main('pwd'),
            homedir: main_homedir,
            spark_path: spark_path,
            user: run_in_main( 'whoami'),
            cnvrg: run_in_main( 'which cnvrg'),
            has_bash: run_in_main( 'which bash'),
            user_id: run_in_main( 'id -u'),
            group_id: run_in_main( 'id -g'),
            python_version: run_in_main( 'python --version'),
            python3_version: run_in_main( 'python3 --version'),
            pip_version: run_in_main( 'pip --version'),
            pip3_version: run_in_main( 'pip3 --version')
        },
    }

    @stats
  end

  def containers
    agent_id = nil
    main_id = nil
    timeout = 2
    timeout = nil if (!@is_new_main || HAS_DOCKER)
    Timeout.timeout(timeout) do
      while agent_id.blank? or main_id.blank?
        grep_by = @job_id
        grep_by = "$(hostname)" if ENV['KUBERNETES_PORT'].present?
        cntrs = `docker ps --format "table {{.ID}},{{.Names}}" 2> /dev/null | grep -i #{grep_by}`.split("\n").map{|x| x.strip}
        agent_id = cntrs.find{|container_name| container_name.include? "agent"}.split(",").first rescue nil
        main_id = cntrs.find{|container_name| container_name.include? @main_name}.split(",").first rescue nil
        sleep(2)
      end
    end
    if main_id.blank?
      raise "Can't find main id"
    end
    [agent_id, main_id]
  rescue => e
    Cnvrg::Logger.log_error(e)
    [agent_id, main_id]
  end

  def current_homedir
    `env | grep -w HOME`.strip.split("=").try(:last)
  end

  def spark_path
    run_in_main("env | grep SPARK_HOME").strip.split("=").try(:last)
  end

  def main_homedir()
    run_in_main("env | grep -w HOME").split("=").try(:last)
  end

  def main_env
    run_in_main("env").split("\n").map{|x| x.split("=")}
  end

  def run_in_main(command)
    data = {cmd: command, async: false, use_sh: true}

    conn = Cnvrg::Helpers::Executer.get_main_conn(timeout: 180)
    response = conn.post('command', data.to_json)
    if response.to_hash[:status].to_i != 200
      Cnvrg::Logger.log_info("Got back bad status #{response.to_hash[:status]}")
      return ""
    end
    resp = []
    lines = response.body.split("\n")
    lines.each do |line|
      next if line.strip == nil or line.strip == ""
      if line.include?("cnvrg-exit-code")
        exit_status = line.split("=")[1].to_i
        if exit_status != 0
          Cnvrg::Logger.log_info("failed to run find command #{command} on main")
          return ""
        end
        next
      end
      resp << line
    end
    return resp.join("\n")
  rescue => e
    Cnvrg::Logger.log_error(e)
    return ""
  end

  def poll
    resp = Cnvrg::API.request([activity_url, "commands"].join('/'), "POST")
    commands = resp["commands"]
    files = resp["files"]
    handle_files(files)
    commands.each{|cmd| @commands_q.push(cmd)}
  rescue => e
    Cnvrg::Logger.log_error(e)
  end

  def init
    retries = 0
    success = false
    puts("Agent started, connecting to #{Cnvrg::API.get_api}")
    STDOUT.flush
    wait_for_main
    while !success and retries < 100
      begin
        resp = Cnvrg::API.request(activity_url, "PUT", {stats: executer_stats})
        if !resp
          raise StandardError.new("Failed to send request to server")
        end
        machine_activity = resp["machine_activity"]
        success = true
        puts("Connected to server")
        STDOUT.flush
        Cnvrg::Logger.log_info("Got back machine activity #{machine_activity}")
        if machine_activity.present? and @machine_activity != machine_activity
          Cnvrg::Logger.log_info("Changing to machine activity #{machine_activity}")
          machine_activity_yml = {slug: machine_activity}
          File.open("/conf/.machine_activity.yml", "w+") {|f| f.write machine_activity_yml.to_yaml}
          @machine_activity = machine_activity
        end
      rescue => e
        Cnvrg::Logger.log_error(e)
        Cnvrg::Logger.info("Sleeping for #{5 * retries}")
        sleep(5 * retries)
        retries +=1
      end
    end
  end

  def polling_thread
    while true
      poll
      sleep(@poll_every)
    end
  end

  def check_main_is_working_thread
    while true
      check_main_alive
      sleep(@check_main_every)
    end
  end

  def main_thread
    init
    Thread.new do
      polling_thread
    end
    Thread.new do
      check_main_is_working_thread
    end
    execute_cmds
  end

  def wait_for_main
    copy_file_to_main
    start_tiny_if_missing
    retries = 0
    puts("Waiting for main container")
    STDOUT.flush
    got_response = false
    while !got_response do
      begin
        conn = Cnvrg::Helpers::Executer.get_main_conn
        response = conn.get('readiness')
        if response.to_hash[:status].to_i != 200
          sleep(0.1)
          next
        else
          puts("Client container is ready")
          STDOUT.flush
          @main_start_time = response.body.to_i
          got_response = true
        end
      rescue => e
        retries += 1
        if retries > 3
          puts("Failed to connect to main")
          puts(e.message)
          STDOUT.flush
        end
        sleep(0.1)
        next
      end
    end
  end

  def copy_file_to_main
    begin
      FileUtils.cp("/cnvrg-tiny", "/conf/tiny")
      FileUtils.cp_r("/scripts", "/conf/scripts-bin")
      FileUtils.touch("/conf/tiny-ready")
    rescue => e
      Cnvrg::Logger.log_error(e)
    end
  end

  def start_tiny_if_missing
    return unless ENV['MAIN_CONTAINER_PORT'].blank?
    Cnvrg::Logger.log_info("Tiny not found, starting it")
    @agent_id, @main_id = containers
    pid = Process.fork do
      Cnvrg::Logger.log_info("running docker exec -i #{@main_id} sh -c '/conf/tiny")
      `docker exec -i #{@main_id} sh -c '/conf/tiny'`.strip
    end
    Process.detach(pid)
    Cnvrg::Logger.log_info("Tiny started and detached")
  end

  def execute_cmds
    pids_by_slug = {}
    while true
      if @commands_q.empty?
        sleep(5)
        next
      end
      cmd = @commands_q.pop.symbolize_keys

      if cmd[:wait_slug].present?
        if pids_by_slug[cmd[:wait_slug]].present?
          other_pid = pids_by_slug[cmd[:wait_slug]]
          begin
            Process.waitpid(other_pid, Process::WNOHANG)
            running = true
          rescue Errno::ECHILD => e
            running = false
          end
          if running
            @commands_q.push(cmd)
            sleep(5)
            next
          end
        end
      end
      command_json = Cnvrg::API.request([activity_url, "commands", cmd[:slug]].join('/'), "GET")

      cmd_status = command_json["status"] rescue ""

      if cmd_status == Cnvrg::Helpers::Agent::Status::ABORTED
        Cnvrg::Logger.log_info("stopping job because command #{cmd[:slug]} with status #{cmd_status}")
        next
      end
      pid = Process.fork do
        Cnvrg::Helpers::Agent.new(executer: self, **cmd).exec!
      end
      if cmd[:async].blank?
        Process.waitpid(pid)
      else
        Process.detach(pid)
      end
      pids_by_slug[cmd[:slug]] = pid
      ######
    end
  end

  def merge_log_block(logs)
    logs.group_by {|log| log[:timestamp].to_s}
        .map {|ts, logz| {timestamp: ts, logs: logz.map {|l| l[:log]}.join("\n")}}
  end

  def get_node_and_pod_names
    pod_name = `hostname`.strip rescue nil
    node_name = nil
    if pod_name.present?
      pod_describe = `kubectl get pod #{pod_name} -o json 2> /dev/null` rescue nil
      pod_describe = JSON.parse(pod_describe) rescue {}
      node_name = pod_describe["spec"]["nodeName"] rescue nil
    end
    [pod_name, node_name]
  end

  def pre_pod_stop
    pod_name, node_name = get_node_and_pod_names
    pod_events = get_pod_events(pod_name)
    node_events = get_node_events(node_name)
    Cnvrg::API.request([activity_url, "job_events"].join('/'), "POST", {pod_events: pod_events, node_events: node_events})
  end

  def check_main_alive
    # Dont check before we got first response
    return if @main_start_time == nil
    conn = Cnvrg::Helpers::Executer.get_main_conn
    response = conn.get('readiness')
    if response.to_hash[:status].to_i != 200
      main_start_time = 0
    else
      main_start_time = response.body.to_i
    end
    if main_start_time != @main_start_time
      puts("Found that main restarted, restarting agent")
      Cnvrg::Logger.log_info("Found that main restarted, restarting agent")
      exit(1)
    end
  end

  def get_pod_events(pod_name)
    return if pod_name.blank?
    `kubectl get event --field-selector involvedObject.name=#{pod_name} -o json`
  end

  def get_node_events(node_name)
    return if node_name.blank?
    `kubectl get event --all-namespaces --field-selector involvedObject.name=#{node_name} -o json`
  end

  def self.main_container_url
    if ENV["CNVRG_COMPUTE_CLUSTER"].blank? and ENV["KUBERNETES_SERVICE_HOST"].blank?
      if ENV["MAIN_CONTAINER_PORT"].blank?
        host = "slave"
      else
        host = "main"
      end
      "http://#{host}:#{Cnvrg::Helpers::Executer::MAIN_CONTAINER_PORT}"
    else
      "http://localhost:#{Cnvrg::Helpers::Executer::MAIN_CONTAINER_PORT}"
    end
  end

  def self.get_main_conn(timeout: 4, open_timeout: 1)
    conn = Faraday.new(
      url: Cnvrg::Helpers::Executer.main_container_url,
      headers: {'Content-Type' => 'application/json'}
    )
    conn.options.timeout = timeout
    conn.options.open_timeout = open_timeout
    conn
  end
end
