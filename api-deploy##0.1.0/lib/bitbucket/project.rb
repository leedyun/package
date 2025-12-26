class Project
  include API
  LIMIT=1000.to_s

  def self.get_all(server)
    data = server.request(:get, "rest/api/1.0/projects?limit=#{LIMIT}")
    data['values'].map {|p| new(server,p) }
  end

  attr_reader :name, :key

  def initialize(server,data)
    @bb = server
    @name = data['name']
    @key = data['key']
  end

  def repositories
    @repositories ||= Repository.get_all(@bb,key)
  end

  def move_all_repos_to_project(new_project)
    repositories.each do |r|
      r.move_repo_to_project(new_project)
    end
  end

  def set_hook_status(key,status,settings=nil)
    repositories.each do |r|
      r.set_hook_settings(key, settings) if status && settings
      r.set_hook_status(key, status)
    end
  end
end
