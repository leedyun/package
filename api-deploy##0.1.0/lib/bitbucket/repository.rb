class Repository
  include API
  LIMIT=1000.to_s

  def self.get_all(bb,project)
    data = bb.request(:get, "rest/api/1.0/projects/#{project}/repos/?limit=#{LIMIT}")
    data['values'].map {|p| new(bb,p) }
  end

  attr_reader :bb, :name, :project

  def initialize(server,data)
    @bb = server
    @name = data['slug']
    @project = data['project']['key']
  end

  def branch_permissions
    bb.request(:get, "rest/branch-permissions/2.0/projects/#{project}/repos/#{name}/restrictions")['values']
  end

  def master_branch_protected?
    !! branch_permissions.detect do |c|
      c["type"] == 'fast-forward-only' && c["matcher"]["id"] == 'refs/heads/master'
    end
  end

  def set_master_branch_protected
    perm = {
      "type"=>"fast-forward-only",
      "matcher"=>
      {"id"=>"refs/heads/master",
       "displayId"=>"master",
       "type"=>{"id"=>"BRANCH", "name"=>"Branch"},
       "active"=>true},
       "users"=>[],
       "groups"=>[]
    }.to_json
    bb.request(:post, "rest/branch-permissions/2.0/projects/#{project}/repos/#{name}/restrictions", perm)
  end

  def move_repo_to_project(new_project)
    bb.request(:post, "/rest/api/1.0/projects/#{project}/repos/#{name}",{project: {key: new_project}}.to_json)
    bb.request(:delete, "/rest/api/1.0/projects/#{project}/repos/#{name}")
  end

  def hooks
    bb.request(:get, "rest/api/1.0/projects/#{project}/repos/#{name}/settings/hooks")
  end

  def set_hook_status(key, status)
    if status
      bb.request(:put, "rest/api/1.0/projects/#{project}/repos/#{name}/settings/hooks/#{key}/enabled")
    else
      bb.request(:delete, "rest/api/1.0/projects/#{project}/repos/#{name}/settings/hooks/#{key}/enabled")
    end
  end

  def hook_settings(key)
    bb.request(:get, "rest/api/1.0/projects/#{project}/repos/#{name}/settings/hooks/#{key}/settings")
  end

  def set_hook_settings(key, settings)
    bb.request(:put, "rest/api/1.0/projects/#{project}/repos/#{name}/settings/hooks/#{key}/settings", settings)
  end
end
