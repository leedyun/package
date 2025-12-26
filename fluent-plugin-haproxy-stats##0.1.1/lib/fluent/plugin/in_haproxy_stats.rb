module Fluent
  class InHaproxyStats < Fluent::Input
    Fluent::Plugin.register_input('haproxy_stats', self)

    unless method_defined?(:log)
      define_method("log") { $log }
    end

    unless method_defined?(:router)
      define_method("router") { Fluent::Engine }
    end

    config_param :interval, :integer, :default => 60
    config_param :stats_file, :string
    config_param :px_name, :string, :default => 'all'
    config_param :sv_name, :string, :default => 'all'
    config_param :tag, :string

    def initialize
      super
      #
      require "haproxy"
    end

    def start
      @finished = false
      @thread = Thread.new(&method(:run))
    end

    def shutdown
      @finished = true
      @thread.join
    end

    def configure(conf)
      super
      #
      unless File.exist?(@stats_file) or File.readable?(@stats_file)
        raise Fluent::ConfigError, 'HAProxy stats file does not exists or does not readable.' 
      end
    end

    private

    def run
      loop do
        sleep @interval
        haproxy = HAProxy.read_stats @stats_file
        haproxy.stats.each do |s|
          time = Time.now
          if @px_name == 'all' and @sv_name == 'all'
            tag = [@tag, 'all'].join(".")
            router.emit(tag, time, s)
          elsif s[:pxname] == @px_name and s[:svname] == @sv_name
            tag = [@tag, @px_name, @sv_name].join(".")
            router.emit(tag, time, s)
          elsif s[:pxname] == @px_name and @sv_name == 'all'
            tag = [@tag, @px_name].join(".")
            router.emit(tag, time, s)
          elsif s[:svname] == @sv_name and @px_name == 'all'
            tag = [@tag, @sv_name].join(".")
            router.emit(tag, time, s)
          end
        end
      end
    end

  end
end
