require 'xcodeproj'

module Pod
  module Helper
    class ProjectBuilder

      def initialize(name,prefix)
        @name = name
        @prefix = prefix
      end

      def build_project
        create_project
        configure_project
        save_project
      end

      def create_project
        @project = Xcodeproj::Project.new(@name, false)
      end

      def save_project
        @project.save("#{@name}/#{@name}.xcodeproj")
        @project
      end

      def configure_project
        create_groups
        create_target
        add_required_files
        add_default_frameworks
      end


      def create_target
        @main_target = @project.new_target(:application, @name, :ios, 7.0)
        @main_target.build_configuration_list.build_configurations.each do |bc|
          bc.build_settings['GCC_PREFIX_HEADER'] = "$(SRCROOT)/#{@name}/Supporting Files/#{@name}-Prefix.pch"
          bc.build_settings['OTHER_LDFLAGS'] = "$(inherited)"
          bc.build_settings['HEADER_SEARCH_PATHS'] = "$(inherited) /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include $(BUILT_PRODUCTS_DIR)/../../Headers"
          bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = "6.0"
          bc.build_settings['CODE_SIGN_IDENTITY'] = "iPhone Developer"
          bc.build_settings['INFOPLIST_FILE'] = "$(SRCROOT)/#{@name}/Supporting Files/#{@name}-Info.plist"
          bc.build_settings['ASSETCATALOG_COMPILER_APPICON_NAME'] = "AppIcon"
          bc.build_settings['ASSETCATALOG_COMPILER_LAUNCHIMAGE_NAME'] = "LaunchImage"
          bc.build_settings['OTHER_LDFLAGS'] = "$(inherited) -ObjC"
          bc.build_settings['FRAMEWORK_SEARCH_PATHS'] = "$(inherited)  $(SRCROOT)/ParisHilton/Frameworks $(SRCROOT)/CoreProductModules/Frameworks"
          bc.build_settings['ARCHS'] = "$(ARCHS_STANDARD_INCLUDING_64_BIT)"
        end

        #Add Create Revision Build Phase
        phase_name = "Create Revision"
        phase = @main_target.new_shell_script_build_phase(phase_name)
        phase.shell_script = "${SRCROOT}/#{@name}/Scripts/Generate-Revision.sh ${PROJECT_NAME} ${PROJECT_DIR}/#{@name}/Revision"
        phase.show_env_vars_in_log = '1'
        @main_target.build_phases.delete(phase)
        @main_target.build_phases.insert(0,phase) # moving create revision build phase to top
    
        #Add Paris Hilton Static Lib
        target_name = "ParisHilton";
        library = @project.frameworks_group.new_product_ref_for_target(target_name, :static_library)
        @main_target.frameworks_build_phase.add_file_reference(library)
    
        #Add CoreProductModules Static Lib
        target_name = "CoreProductModules";
        library = @project.frameworks_group.new_product_ref_for_target(target_name, :static_library)
        @main_target.frameworks_build_phase.add_file_reference(library)
      
        #Add Google Analytics
        path = "ParisHilton/Frameworks/GoogleAnalytics.framework"
        gref = @project.frameworks_group.new_file(path)
        @main_target.frameworks_build_phase.add_file_reference(gref, true)

        #Add zbar
        path = "CoreProductModules/Frameworks/zbar.framework"
        zref = @project.frameworks_group.new_file(path)
        @main_target.frameworks_build_phase.add_file_reference(zref, true)        
      end

      def create_groups
        @sources = @project.new_group "#{@name}"
        @skinners = @sources.new_group "Skinners"
        @resources = @sources.new_group "Resources"
        @common_resources = @resources.new_group "Common"
        @common_resources_fonts = @common_resources.new_group "Fonts"
        @revision = @sources.new_group "Revision"
        @supporting_files= @sources.new_group "Supporting Files"
      end

      def add_required_files
        sources_dir = "#{@name}/"
        resources_dir = "#{sources_dir}Resources/"
        common_resources_dir = "#{resources_dir}Common/"
        common_resources_fonts_dir = "#{common_resources_dir}Fonts/"
        supporting_files_dir = "#{sources_dir}Supporting Files/"
        revision_dir = "#{sources_dir}Revision/"
        skinner_dir = "#{sources_dir}Skinners/"

        @sources.new_file(sources_dir + BootstrapDelegateH.new(@name,@prefix).name)
        adm_ref = @sources.new_file(sources_dir + BootstrapDelegateM.new(@name,@prefix).name)

        @supporting_files.new_file(Readme.new(@name,@prefix).name)
        @supporting_files.new_file(supporting_files_dir + InfoPlist.new(@name,@prefix).name)
        @supporting_files.new_file(supporting_files_dir + PrefixHeader.new(@name,@prefix).name)
        mainm_ref = @supporting_files.new_file(supporting_files_dir + MainM.new(@name,@prefix).name)

        @skinners.new_file(skinner_dir + SidebarContainerViewControllerSkinnerH.new(@name,@prefix).name)
        skm_ref = @skinners.new_file(skinner_dir + SidebarContainerViewControllerSkinnerM.new(@name,@prefix).name)

        @revision.new_file(revision_dir + "revision.h")
        rev_ref = @revision.new_file(revision_dir + "revision.m")

        #Add app asset catalog
        ac_ref = @resources.new_file(resources_dir + "Assets.xcassets")

        #Add common files
        cac_ref = @common_resources.new_file(common_resources_dir + "Assets.xcassets")
        ajson_ref = @common_resources.new_file(common_resources_dir + "AnalyticsStrings.json")
        ljson_ref = @common_resources.new_file(common_resources_dir + "en.lproj/LocalizableStrings.json")
        istrings_ref = @common_resources.new_file(common_resources_dir + "en.lproj/InfoPlist.strings")
        demo_ref = @common_resources.new_reference(common_resources_dir + "en.lproj/Demo")

        #Add common fonts
        f1_ref = @common_resources_fonts.new_file(common_resources_fonts_dir + "InterFaceCorp-Bold.ttf")
        f2_ref =  @common_resources_fonts.new_file(common_resources_fonts_dir + "InterFaceCorp-Regular.ttf")

        @main_target.add_file_references([adm_ref, mainm_ref, rev_ref, skm_ref])
        @main_target.add_resources([ac_ref,cac_ref,f1_ref,f2_ref,ajson_ref,ljson_ref,istrings_ref,demo_ref])
      end

      def add_default_frameworks
        @main_target.add_system_libraries [ 'xml2', 'iconv', 'sqlite3.0', 'z' ]
        @main_target.add_system_frameworks [ 'MapKit', 'QuartzCore', 'AdSupport', 'AVFoundation', 'CoreVideo', 'CoreText', 'CoreMedia', 'CoreLocation', 'CoreData', 'Foundation', 'UIKit', 'CoreGraphics', 'SystemConfiguration' ]
      end
    end
  end
end
