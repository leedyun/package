class Cnvrg::Helpers::Agent

  module Status
    STARTED = :started
    RUNNING = :running
    FINISHED = :finished
    ABORTED = "aborted"
  end

  module LogLevel
    INFO = :info
    PURE = :pure
    ERROR = :error
  end

  #### This class represent a single command in the system.
  #### it runs under an executer (machine_activity) so it should have all the executer
  #### params
  def initialize(executer: nil, slug: nil, command: nil, container_name: nil, send_log_interval: 60, timeout: -1, logs_regex: [], async: false, send_logs: false, files_exist: [], retries: 0, sleep_before_retry: 30, single_quotes: false, docker_user: nil, use_bash: false, **kwargs)
    @executer = executer
    @job_id = ENV["CNVRG_JOB_ID"]
    @slug = slug
    @files_exist = files_exist
    @container_name = container_name
    @execute_command_completed = false
    @is_new_main = !ENV["MAIN_CONTAINER_PORT"].blank?
    @main_name = @is_new_main ? "main" : "slave"
    @run_in_main = @container_name.downcase == @main_name
    @log_interval = send_log_interval
    # https://ruby-doc.org/stdlib-2.5.1/libdoc/timeout/rdoc/Timeout.html timeout should be 0 for running forever
    if timeout.blank? or timeout.negative?
      @timeout = 0
    else
      @timeout = timeout
    end
    @logs_regex = logs_regex || []
    @async = async
    @command = command
    @send_logs = send_logs
    @retries = retries.try(:to_i) ## How many times the user asked to try to execute the command again
    @sleep_before_retry = sleep_before_retry
    @real_execution_retries = 0 ## How many times the command really executed until success
    @single_quotes = single_quotes
    @docker_user = docker_user
    @use_bash = use_bash
    @output = []
    @errors = []
    @exit_status = nil
    @is_running = true
    @pid = nil
  end

  def base_url
    [@executer.activity_url, "commands", @slug].join("/")
  end

  def should_run?
    if @files_exist.present?
      file_doesnt_exists = @files_exist.find do |file|
        not File.exists? file
      end
      return true if file_doesnt_exists.blank?
      return false
    end
    true
  end


  def exec!
    log_internal("Command: #{@command} with slug: #{@slug} started!")
    command_status = Status::FINISHED
    if @command.blank?
      @exit_status = 0
      command_status = Status::ABORTED
    elsif should_run?
      send_logs(status: Status::STARTED)
      periodic_thread_handle = periodic_thread
      execute_command
    else
      command_status = Status::ABORTED
      @exit_status = 127
    end
    @execute_command_completed = true
    finish_log = "Command: #{@command} with slug: #{@slug} finished"
    finish_log += " after #{@real_execution_retries} retries" if @real_execution_retries > 0
    log_internal(finish_log)
    send_logs(exit_status: @exit_status, status: command_status)
    if periodic_thread_handle.present?
      periodic_thread_handle.join
    end
  end

  def get_logs_to_send
    new_logs = @output.pop(@output.length)
    new_errors = @errors.pop(@errors.length)
    [new_logs, new_errors]
  end


  def periodic_thread
    Thread.new do
        while !@execute_command_completed
          Thread.exit if @log_interval.blank?
          sleep(@log_interval)
          send_logs
        end
    end
  end

  def retry_command
    @retries -=1
    sleep @sleep_before_retry
    @real_execution_retries +=1
    execute_command
  end

  def execute_command_on_slave
    extra_slug = (0...2).map { (65 + rand(26)).chr }.join
    result_file = "/conf/result-#{@slug}-#{extra_slug}"
    Timeout.timeout(@timeout) do
      data = {cmd: @command, async: true, file_name: result_file, use_script: true, use_bash: @use_bash, use_sh: !@use_bash, docker_user: @docker_user}
      conn = Cnvrg::Helpers::Executer.get_main_conn
      response = conn.post('command', data.to_json)
      if response.to_hash[:status].to_i != 200
        @exit_status = 129
        raise StandardError.new("Cant send command to slave")
      end
      t = FileWatch::Tail.new
      filename = result_file
      t.tail(filename)
      t.subscribe do |path, line|
        if line.include?("cnvrg-exit-code")
          @exit_status = line.split("=")[1].to_i
          break
        end
        if !@is_new_main
          log_internal(line, level: LogLevel::PURE)
        end
        line = line.encode('utf-8', :invalid => :replace, :undef => :replace, :replace => '_')
        @output << {log: line, timestamp: Time.now}
      end
    end
  rescue Timeout::Error
    @errors << {log: "Command timed out!", timestamp: Time.now}
    log_internal("Command timed out!", level: LogLevel::ERROR)
    @exit_status = 124
  ensure
    retry_command if @retries != 0 and @exit_status !=0
    @exit_status
  end

  def execute_command
    return execute_command_on_slave if @run_in_main
    Timeout.timeout(@timeout) do
      PTY.spawn(@command) do |stdout, stdin, pid, stderr|
        @pid = pid
        begin
          if stdout.present?
            stdout.each do |line|
              log_internal(line, level: LogLevel::INFO)
              line = line.strip.gsub(/\e\[([;\d]+)?m/, '')
              @output << {log: line, timestamp: Time.now}
            end
          end

          if stderr.present?
            stderr.each do |line|
              line = line.strip.gsub(/\e\[([;\d]+)?m/, '')
              log_internal(line, level: LogLevel::ERROR)
              @errors << {log: line, timestamp: Time.now}
            end
          end
        rescue Errno::EIO => e
          next
        rescue => e
          log_internal(e.message, level: LogLevel::ERROR)
          log_internal(e.backtrace.join("\n"), level: LogLevel::ERROR)
          @errors << {log: e.message, timestamp: Time.now}
        end
        ::Process.wait pid
      end
    end
    @exit_status = $?.exitstatus
  rescue NoMethodError => e
    log_internal("No Method Error: #{e}", level: LogLevel::ERROR)
    @exit_status = 129
  rescue Timeout::Error
    Process.kill(0, @pid)
    @errors << {log: "Command timed out!", timestamp: Time.now}
    log_internal("Command timed out!", level: LogLevel::ERROR)
    @exit_status = 124
  rescue => e
    log_internal("Error: #{e}", level: LogLevel::ERROR)
    @exit_status = 129
  ensure
    retry_command if @retries != 0 and @exit_status !=0
    @exit_status
  end

  private
  def send_logs(exit_status: nil, status: Status::RUNNING)
    logs, error_logs = get_logs_to_send
    # Filter logs only if not failed
    if exit_status.blank? or exit_status == 0
      logs = filter_logs_by_regex(logs)
    end
    ### there is no logs, no exit_status and status is running.
    ### this condition let us call "send_logs" every interval iteration.
    if logs.blank? and error_logs.blank? and exit_status.blank? and status == Status::RUNNING
      return
    end
    Cnvrg::API.request(base_url, 'PUT', {logs: logs, error_logs: error_logs, exit_status: exit_status, status: status, execution_retries: @real_execution_retries, pid: @pid})
  end

  def log_internal(log, level: LogLevel::INFO)
    if level == LogLevel::PURE
      puts(log)
      STDOUT.flush
      return
    end
    to_print = {message: log, level: level, timestamp: Time.now, command: @slug, machine_activity: @executer.machine_activity, job: @job_id}
    if log.start_with?("{") and log.include?("timestamp")
      log_json = JSON.parse(log)
      to_print = to_print.stringify_keys.merge(log_json.stringify_keys)
    end
    puts(to_print.to_json)
    STDOUT.flush
  rescue => e
    Cnvrg::Logger.log_error(e)
  end

  def filter_logs_by_regex(logs)
    logs.select do |log|
      next true if @send_logs
      @logs_regex.find do |regexp_str|
        Regexp.new(regexp_str).match(log[:log]).present?
      end
    end
  end
end
