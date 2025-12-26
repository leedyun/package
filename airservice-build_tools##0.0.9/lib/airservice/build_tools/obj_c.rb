require 'plist'
require 'airservice/build_tools'
module AirService
  module BuildTools
    module ObjC
      include Logger
      def update_plist_version(options={})
        plist_file_path = options[:file_path]
        raise 'Plist file path as file_path' unless plist_file_path
        raise "Specified file #{plist_file_path} doesn't exists" unless File.exists?(plist_file_path)
        log "Opening plist #{plist_file_path}"
        plist = Plist::parse_xml(plist_file_path)

        build_version = options[:build_version]
        plist['CFBundleVersion'] = build_version.to_s if build_version
        version = options[:version]
        plist['CFBundleShortVersionString'] = version.to_s if version

        log "Updating plist to #{plist.inspect}"
        new_plist_content = plist.to_plist
        File.open(plist_file_path, 'w+') { |f| f.write(new_plist_content) }
      end

      def create_ios_icons(options={})
        sizes = [
          {size: 76, name: 'ipad', scale: [1, 2]},
          {size: 40, name: 'ipad_spotlight', scale: [1, 2]},
          {size: 29, name: 'ipad_settings', scale: [1, 2]},
          {size: 60, name: 'iphone', scale: [2]},
          {size: 40, name: 'iphone_spotlight', scale: [2]},
          {size: 29, name: 'iphone_settings', scale: [2]},
          {size: 512, name: 'iTunesArtwork', scale: [2]},
        ]
        source = options.fetch(:source)
        raise "Source file #{source} doesn't exists" unless File.exists?(source)
        output_dir = options.fetch(:output_dir)
        FileUtils.mkdir_p(output_dir)

        sizes.each do |size|
          size[:scale].each do |scale|
            scaled_size = size[:size] * scale
            target_size = "#{scaled_size}x#{scaled_size}"
            output_file = "#{size[:name]}@#{scale}x.png"
            args = %W[#{File.expand_path(source, '.')}
                  -resize #{target_size}
                  #{File.join(output_dir, output_file)}]
            system('convert', *args)
          end
        end
      end
    end
  end
end
