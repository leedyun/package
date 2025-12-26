module LogsViewer
  class Display

    def initialize(app)
      @app = app
      @number_lines = LogsViewer::Config.number_lines
      @log_dir = LogsViewer::Config.log_dir
    end

    def call(env = {})
      if env["PATH_INFO"]=~/^\/logs/
        @data = {
          list: LogsViewer::Handler.list(@log_dir),
          lines: []
        }

        params = Rack::Utils.parse_nested_query(env["QUERY_STRING"])

        if params.has_key? 'file'
          log_file = params['file']
          number_lines = (params.has_key? 'number_lines') ? params['number_lines'] : @number_lines

          @data[:lines] = `tail -n "#{number_lines}" "#{log_file}"`
          [200,{"Content-Type"=>"text/html"},[view_generate(@data)]]
        else
          [200,{"Content-Type"=>"text/html"},[view_generate(@data)]]
        end
      else
        @app.call(env)
      end
    end

    def view_generate(data)
      temp = LogsViewer::Handler.file_open("../views/display.html.erb")
      temp = ERB.new(temp)
      return temp.result(binding)
    end

  end
end