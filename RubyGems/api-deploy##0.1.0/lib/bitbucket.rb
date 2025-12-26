class Bitbucket
  include API
  LIMIT=1000.to_s

  HOOK_EXCLUSIONS = ['WSC','CM','YOMS']

  def initialize
    create_api( ConfigStore.bitbucket )
  end

  def projects
    @projects ||= Project.get_all(self)
  end

  def set_master_branch_protected_on_all_projects
    projects.map do |project|
      project.repositories.map do |r|
        r.set_master_branch_protected unless r.master_branch_protected?
      end
    end
  end

  def set_hook_status_on_all_projects(key,status,settings=nil)
    projects.map do |project|
      next if HOOK_EXCLUSIONS.include?(project.key)
      project.set_hook_status(key, status, settings)
    end
  end

  def remove_hooks_on_exclusions
    projects.select {|p| HOOK_EXCLUSIONS.include? p.key }.each do |project|
      [
        'org.christiangalsterer.stash-filehooks-plugin:filesize-hook',
        "org.christiangalsterer.stash-filehooks-plugin:filename-hook",
      ].each do |key|
        project.set_hook_status(key, false)
      end
    end
  end

  def apply_restrictions
    set_hook_status_on_all_projects(
      "org.christiangalsterer.stash-filehooks-plugin:filesize-hook",
      true,
      {
        "pattern-1"=>".*",
        "size-1"=>"10485760",
        "pattern-exclude-1"=>"",
        "pattern-branches-1"=>""
      }.to_json
    )

    set_hook_status_on_all_projects(
      "org.christiangalsterer.stash-filehooks-plugin:filename-hook",
      false,
      {
        "pattern"=>"\\.(h26.?|mp.?.?|avi|webm|flv|tar(\\..?.?.?)?|zip|7z|rar|exe|msi|rpm|deb)$",
        "pattern-exclude"=>"",
        "pattern-branches"=>""
      }.to_json
    )

    set_master_branch_protected_on_all_projects

    # cleanup TRAIN project
    projects.detect {|p| p.key == 'TRAIN'}.move_all_repos_to_project('TOLD')
  end
end
