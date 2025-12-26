module ContributorsStats

  # Placeholder for updater plugins
  module Updater
  end

  # Takes care of formatting data and saving it
  class Formatter
    attr_reader :content

    def initialize(data, type = :html, options = {})
       format(data, type, options)
    end

    # overwrite target with the formatted content
    # @param targets [Array] list of files to overwrite
    def save(*targets)
      targets.flatten.each do |file|
        File.open(file, 'w') { |f| f.write(content * "\n") }
      end
    end

    # update target with the formatted content
    # @param targets [Array] list of files to update
    # @param options [Hash] options are passed to updater plugin, check
    def update(*targets, options: {})
      targets.flatten.each do |file|
        plugin = plugins.first_ask!("updater", :handles?, file)
        update_file(file) do |file_content|
          plugin.update(file_content, content, options)
        end
      end
    end

  private

    def plugins
      @plugins ||= Pluginator.find("contributors_stats", extends: %i{first_ask first_class})
    end

    def format(data, type = :html, options = {})
      formatter_plugin = plugins.first_class!("formatter", type).new(options)
      @content = data.map do |login, user_data|
        formatter_plugin.format(login, user_data)
      end
    end

    # Allow editing file text in a block
    # @example
    #     update_file('some.txt'){|text| text.gsub(/bla/,'ble')}
    def update_file(file)
      text = File.read(file)
      text = yield text
      File.open(file, 'w') { |f| f.write(text) }
    end
  end
end
