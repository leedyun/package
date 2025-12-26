require 'erb'

module Pod
  module Helper
    class TemplateFile

      def initialize(project_name,project_prefix)
        @project_name = project_name
        @project_prefix = project_prefix
        @project_year = Date.today.strftime('%Y')
        @project_identifier = "com.icemobile.#{project_name.downcase}"
      end

      def fixture_path
        File.join(File.dirname(File.expand_path(__FILE__)), '../../../fixtures')
      end

      def write
        output_file = nil
        File.open(name, 'w') do |output_file|
          output_file.puts template.result binding
        end
        output_file
      end

      def exists?
        File.exists?(name)
      end

      public
    
      def name
        "TemplateFile" 
      end

      def file
        if exists?
          File.read(name)
        else
          write
        end
      end

      def template
        ERB.new(File.read("#{fixture_path}/#{template_name}.erb"))
      end

      def template_name
        name
      end
    end

    class Gitignore < TemplateFile
      def name
        '.gitignore'
      end
    end

    class BootstrapDelegateH < TemplateFile
      def name
        "#{@project_prefix}BootstrapDelegate.h"
      end

      def template_name
        'BootstrapDelegate.h'
      end
    end

    class BootstrapDelegateM < TemplateFile
      def name
        "#{@project_prefix}BootstrapDelegate.m"
      end

      def template_name
        'BootstrapDelegate.m'
      end
    end

    class InfoPlist < TemplateFile
      def name
        "#{@project_name}-Info.plist"
      end

      def template_name
        'Info.plist'
      end
    end

    class MainM < TemplateFile
      def name
        'main.m'
      end
    end

    class Podfile < TemplateFile
      def name
        'Podfile'
      end
    end

    class PrefixHeader < TemplateFile
      def name
       "#{@project_name}-Prefix.pch"
      end

      def template_name
        'Prefix.pch'
      end
    end

    class Readme < TemplateFile
      def name
        'README.md'
      end
    end

    class SidebarContainerViewControllerSkinnerH < TemplateFile
      def name
        "BFSidebarContainerViewController#{@project_prefix}Skinner.h"
      end

      def template_name
        'SidebarContainerViewControllerSkinner.h'
      end
    end

    class SidebarContainerViewControllerSkinnerM < TemplateFile
      def name
        "BFSidebarContainerViewController#{@project_prefix}Skinner.m"
      end

      def template_name
        'SidebarContainerViewControllerSkinner.m'
      end
    end

  end
end
