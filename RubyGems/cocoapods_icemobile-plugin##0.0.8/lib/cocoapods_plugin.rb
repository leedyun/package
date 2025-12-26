require 'cocoapods-icemobile-plugin'
require 'cocoapods'
require 'xcodeproj'

COCOAPODS_WORKSPACE_PATH = nil
PODS_PROJECT_PATH = "Pods/Pods.xcodeproj"
BRIGHT_PROJECT_PATHS = [ "ParisHilton/ParisHilton.xcodeproj",
                         "CoreProductModules/CoreProductModules.xcodeproj"]

Pod::Command.class_eval do
    self.description = 'CocoaPods, the Objective-C library package manager.(Plugged in by cocoapods-icemobile-plugin)'
end

Pod::Installer.class_eval do
	def install!
   		resolve_dependencies
   		download_dependencies
   		generate_pods_project
   		integrate_user_project if config.integrate_targets?
   		if is_bright_project?
        integrate_bright_projects 
      else
        puts "Bright Project Not Detected"
      end
   	end

    def is_bright_project?
      project_paths = BRIGHT_PROJECT_PATHS
      project_paths.each do |project_path|
          return false if !File.exist?(project_path)
      end
      return true
    end

   	def integrate_bright_projects
   		puts "Integrating Bright Projects Into Workspace"
   		workspace = Xcodeproj::Workspace.new_from_xcworkspace($COCOAPODS_WORKSPACE_PATH)

      project_paths = BRIGHT_PROJECT_PATHS
      project_paths.each do |project_path|
          workspace.projpaths.push(project_path) unless workspace.projpaths.include?(project_path)
      end

      pods_project_path = PODS_PROJECT_PATH
      if podfile.target_definitions.values.all?{ |td| td.empty? }
          workspace.projpaths.delete(pods_project_path) if workspace.projpaths.include?(pods_project_path)
      end

      workspace.save_as($COCOAPODS_WORKSPACE_PATH)
  end
end

Pod::Installer::UserProjectIntegrator.class_eval do
    def integrate!
        create_workspace
        integrate_user_targets
        $COCOAPODS_WORKSPACE_PATH = workspace_path
    end
end