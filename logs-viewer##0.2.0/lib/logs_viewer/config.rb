module LogsViewer
  class Config
    cattr_reader :number_lines, :log_dir
    cattr_writer :number_lines, :log_dir

    @@number_lines ||= 1000
    @@log_dir ||= "log"

  end
end