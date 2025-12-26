module Cnvrg
  class Flows
    def initialize(flow_slug, project: nil)
      @project = project || Cnvrg::Project.new(Cnvrg::CLI.get_project_home)
      @flow_info= Flows.resolve_flow_title(flow_slug, project)
      @slug = @flow_info["slug"]
      @tasks = {}
      @relations = {}
      @title = nil
      @base_resource = @project.base_resource + "flows/#{@slug}"
      @public_url = "#{@project.url}/flows/#{@slug}"
      # self.reload_flow
    end

    def self.resolve_flow_title(title, project)
      resp = Cnvrg::API.request("#{project.base_resource}/flows", 'GET')
      if resp.blank?
        raise StandardError.new("Can't resolve flow")
      end
      res = resp["result"].find{|flow| flow["slug"].downcase == title.downcase}
      res ||= resp["result"].find{|flow| flow["title"].downcase == title.downcase}
      if res.blank?
        raise StandardError.new("Can't find flow with title #{title}")
      end
      res
    end

    def edit_href
      "#{@public_url}/flow_versions/new"
    end

    def edit_version_href(version)
      return "#{edit_href}?flow_version_slug=#{version}"
    end

    def version_href(version=nil)
      "#{@base_resource}/flow_versions/#{version || 'latest'}"
    end

    def export(version, file: nil)
      resp = Cnvrg::API.request(version_href(version), 'GET')
      if resp["status"] != 200
        raise StandardError.new("Cant find flow version: #{version} for flow: #{@slug}")
      end
      flow_version = resp["flow_version"]
      api_recipe = flow_version["api_recipe"]
      file = file.presence  || "flow-#{@slug.downcase.gsub("\s", "_")}.yml"
      File.open(file, "w"){|f| f.write api_recipe.to_yaml}
      file
    end

    def get_version(version)


    end

    def self.create_flow(project, recipe, run: false)
      url = "#{project.base_resource}flows"
      if run
        url += "/run"
      end
      resp = Cnvrg::API.request(url, 'POST', {flow_version: recipe.to_json}) || {}
      if resp["status"] == 200
        return [Flows.new(resp["flow_version"]["flow_id"], project: project), resp["flow_version"]["id"]]
      elsif resp["status"].between?(400,499)
        raise StandardError.new(resp["message"])
      end
      raise StandardError.new("Can't create new flow")
    end

    def get_flow
      unless File.exists? @fullpath
        raise StandardError.new("Cant find flow in #{@fullpath}")
      end
      YAML.load_file(@fullpath)
    end

    def set_flow(new_flow)
      File.open(@fullpath, "w"){|file| file.write new_flow.to_yaml}
    end

    def set_flow_slug(slug)
      flow = self.get_flow
      flow[:slug] = slug
      self.set_flow(flow)
    end

    def reload_flow
      flow = self.get_flow
      @title = flow[:title]
      @slug = flow[:slug]
      @relations = flow[:relations]
      local_tasks = flow[:tasks] || {}
      @relations.each do |relation|
        relation.values.each do |task|
          if local_tasks[task].present?
            @tasks[task] = Cnvrg::Task.new(@project.local_path, content: local_tasks[task])
          else
            @tasks[task] = Cnvrg::Task.new(@project.local_path, path: task)
          end
        end
      end
    end


    def run
      resp = Cnvrg::API.request("#{@base_resource}/#{@slug}/run", 'POST')
      if Cnvrg::CLI.is_response_success(resp)
        return resp
      end
      Cnvrg::CLI.log_message("Cant run flow #{@slug}")
    end

    ### in use for yaml file
    # def run
    #   resp = Cnvrg::API.request(@base_resource, 'POST', {data: to_api})
    #   Cnvrg::CLI.is_response_success(resp, true)
    #   flow_slug = resp['result']['flow']
    #   self.set_flow_slug(flow_slug)
    #   url = Cnvrg::Helpers.remote_url + resp['result']['url']
    #   return url
    # end


    private
    def to_api
      {
          relations: @relations,
          tasks: @tasks.keys.map{|task| [task, @tasks[task].to_api]}.to_h,
          title: @title,
          slug: @slug
      }
    end


  end
end