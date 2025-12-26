require 'airservice/build_tools'

module AirService
  module BuildTools
    module Android
      include Logger
      def create_android_icons(options={})
        sizes = [
          {size: 36, folder: 'drawable'},
          {size: 36, folder: 'drawable-ldpi'},
          {size: 48, folder: 'drawable-mdpi'},
          {size: 72, folder: 'drawable-hdpi'},
          {size: 96, folder: 'drawable-xhdpi'}
        ]
        source = options.fetch(:source)
        raise "Source file #{source} doesn't exists" unless File.exists?(source)
        output_dir = options.fetch(:output_dir)
        FileUtils.mkdir_p(output_dir)

        sizes.each do |size|
          folder_path = File.join(output_dir, size[:folder])
          FileUtils.mkdir_p(folder_path)

          target_size = "#{size[:size]}x#{size[:size]}"
          output_file = "icon.png"
          args = %W[#{File.expand_path(source, '.')}
                -resize #{target_size}
          #{File.join(output_dir, size[:folder], output_file)}]
          system('convert', *args)
        end
      end
    end
  end
end
