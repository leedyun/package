module Cnvrg
  class Hyper
    def initialize(project_path, path)
      @project = Cnvrg::Project.new(project_path)
      @content = YAML.load_file(path)
      @base_resource = "users/#{@project.owner}"
      @params = []
    end

    def resolve_params
      resp = Cnvrg::API.request(@base_resource + "/resolve_grid", "POST", {hyper_search: @content})
      unless Cnvrg::CLI.is_response_success(resp, false)
        return nil
      end
      resp['result']['params'].each do |param|
        @params << {key: param.first.keys.first, value: param.map{|p| p.values}.flatten.join(',')}
      end
      @params
    end
  end
end