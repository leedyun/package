module Cnvrg
  module Logger
    extend self
    def log_handler
      begin
        date = DateTime.now.strftime("%m_%d_%Y")
        home_dir = File.expand_path('~')

        if !File.directory? home_dir + "/.cnvrg"
          FileUtils.mkdir_p([home_dir + "/.cnvrg", home_dir + "/.cnvrg/tmp"])
        end
        if !File.exist?(home_dir + "/.cnvrg/config.yml")
          FileUtils.touch [home_dir + "/.cnvrg/config.yml"]
        end
        logfile = File.expand_path('~') + "/.cnvrg/log_#{date}.log"
        if !File.exist? logfile
          FileUtils.touch([logfile])
          yesterday = get_start_day - 86399
          date = yesterday.strftime("%m_%d_%Y")

          logfile_old = File.expand_path('~') + "/.cnvrg/log_#{date}.log"
          count = 0
          while not File.exist? logfile_old and count < 60
            yesterday = yesterday - 86399
            date = yesterday.strftime("%m_%d_%Y")
            logfile_old = File.expand_path('~') + "/.cnvrg/log_#{date}.log"
            count += 1
          end
          if File.exist? logfile_old
            @files = Cnvrg::Files.new(Cnvrg::CLI.get_owner, "")
            @files.upload_log_file(logfile_old, "log_#{date}.log", yesterday)
            FileUtils.remove logfile_old
          end

        end
        config = LogStashLogger.configure do |config|
          config.customize_event do |event|
            event.remove('@version')
            event.remove('severity')
          end
        end
        $log = LogStashLogger.new(type: :file, path: logfile, sync: true, config: config)
        self.remove_old_log_files
      rescue
      end
    end

    def remove_old_log_files()
      begin
        last_week = (Time.now - (7 * 24 * 60 * 60)).strftime("%Y-%m-%d")
        home = File.expand_path('~')
        log_files = Dir["#{home}/.cnvrg/tmp/*.log"]
        log_files.each do |l|
          if File.mtime(l).strftime("%Y-%m-%d") < last_week
            FileUtils.rm_rf(l)
          end
        end
      end
    end

    def info(msg)
      self.log_info(msg)
    end

    def log_method(bind: nil)
      return if bind.blank?
      Cnvrg::Logger.log_handler if $log.blank?
      arg = {}
      bind.local_variables.map do |name|
        arg[name] = bind.local_variable_get(name).try(:to_s)
      end
      method = bind.eval('__method__')
      $log.info method: method, args: arg
    end

    def log_error(e)
      Cnvrg::Logger.log_handler if $log.blank?
      return if $log.blank?
      bc = ActiveSupport::BacktraceCleaner.new
      bc.add_silencer{|line| line =~ /thor/}
      $log.error message: "An exception #{e.class} was logged during running", type: "error"
      backtrace = bc.clean(e.backtrace).slice(0,12).map.with_index{|backtrace,idx| "(#{idx}) - #{backtrace}"}.join("; ")
      $log.error message: e.message, type: "error", backtrace: backtrace
    end

    def log_error_message(msg)
      Cnvrg::Logger.log_handler if $log.blank?
      return if $log.blank?
      $log.error message: msg, type: "error"
    end

    def log_info(msg)
      Cnvrg::Logger.log_handler if $log.blank?
      return if $log.blank?
      $log.info message: msg, type: "info"
    end

    def log_json(json, msg: '')
      Cnvrg::Logger.log_handler if $log.blank?
      return if $log.blank?
      $log.info message: msg, type: "info", data: json
    end

    def jsonify_message(msg: '', success: true)
      puts JSON[{
          "msg": msg,
          "success": success.to_s
      }]
    end
  end
end