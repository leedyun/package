module Cnvrg
  class Task
    attr_accessor :title, :path, :source
    def initialize(project_path, path: nil, content: {})
      @path = path
      @content = content
      @source = 'flow' if @content.present?
      @source = 'file' if @path.present?
      @project = Cnvrg::Project.new(project_path)
      @project_path = project_path
      #generic
      @type = nil #type can be exec, data, library, deploy
      @compute = 'medium'
      @title = nil
      @uid = nil
      @params = {}

      #exec
      @cmd = nil
      @params_path = nil

      #library
      @library = nil

      #dataset
      @dataset = nil
      @query = nil

      #deploy
      @function = nil


      @base_resource = @project.base_resource + "/tasks"

      self.reload_task
    end

    def save
      path = @path || gen_path
      File.open(path, 'w'){|f| f.write(get_content.to_yaml)}
    end

    def reload_task
      task_raw = get_content
      @title = task_raw[:title]
      @type = task_raw[:type]
      @uid = task_raw[:uid]
      @title = task_raw[:title] || @uid
      @compute = task_raw[:compute] || @compute

      case @type
      when 'exec'
        @cmd = task_raw[:cmd]
        init_params(task_raw)
      when 'library'
        @library = task_raw[:library]
        init_params(task_raw)
      when 'data'
        @dataset = task_raw[:dataset]
        @query = task_raw[:query]
      when 'deploy'
        @cmd = task_raw[:cmd]
        @function = task_raw[:function]
      else
        error("Cant parse task of type #{@type}")
      end
    end

    def verify_task
      case @type
      when 'exec'
        verify_exec
      when 'data'
        verify_data
      when 'deploy'
        verify_deploy
      when 'library'
        verify_library
      else
        error("Cant parse task of type #{@type}")
      end
    end


    def to_api
      get_content.merge(params: @params)
    end

    def run
      verify_task
      if @type == 'data'
        raise StandardError.new("Data Tasks are not runnable")
      end
      resp = Cnvrg::API.request(@base_resource, "POST", {task: to_api})
      Cnvrg::CLI.is_response_success(resp, true)
      Cnvrg::Helpers.remote_url + resp['result']['url']
    end

    private
    def verify_compute
      unless @project.check_machine(@compute)
        raise StandardError.new("Cant find #{@compute} machine in project.")
      end
    end

    def init_params(task_raw)
      @params_path = task_raw[:params_path].presence
      @params = task_raw[:params] || @params
      if @params_path.present?
        @hyper = Cnvrg::Hyper.new(@project_path, @params_path)
        @params = @hyper.resolve_params
      end
    end

    def verify_exec
      if @cmd.blank?
        error("Cant find command")
      end
      verify_compute
    end

    def verify_data
      if @dataset.blank?
        error("Cant find dataset slug")
      end
    end

    def verify_deploy
      error("Cant find command") if @cmd.blank?
      error("Cant find function") if @function.blank?
      verify_compute
    end

    def verify_library
      error("Cant find library") if @library.blank?
    end

    def get_content
      return @content if @source == 'flow'
      unless File.exists? @path
        raise StandardError.new("Cant find task in #{@path}")
      end
      YAML.load_file(@path)
    end

    def gen_path
      @title ||= "#{@type.capitalize}Task"
      unless File.exists? @title
        @path = "#{@title}.task.yaml"
        return @path
      end
      i = 0
      while File.exists? "#{@title}_#{i}.task.yaml"
        i += 1
      end
      @path = "#{@title}.task.yaml"
      return @path
    end

    def error(msg)
      raise StandardError.new("task: #{@uid} - #{msg}")
    end

  end
end