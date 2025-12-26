#!/usr/bin/env ruby

require 'active_support'
require 'active_support/core_ext'
require 'tilt'

$LOAD_PATH.unshift File.expand_path('../../../app', __FILE__)
$LOAD_PATH.unshift File.expand_path('../../../examples', __FILE__)

$LOAD_PATH.unshift File.expand_path('../app', ENV['BUNDLE_GEMFILE'])

module SeleniumSpider
  class CommandLine
    def self.execute(options)
      new(options)
    end

    def initialize(options)
      @options = options

      if @options[:command] == 'run'
        run
      elsif @options[:command] == 'generate'
        generate
      end
    end

    def run
      if @options[:headless]
        headless = Headless.new(reuse: false, destroy_at_exit: true)
        headless.start
      end

      require "models/#{@options[:site]}"
      require "paginations/#{@options[:site]}_pagination"
      require "controllers/#{@options[:site]}_controller"

      class_name = @options[:site].classify + 'Controller'
      Object.const_get(class_name).new.run

      if @options[:headless]
        headless.destroy
      end
    end

    def generate
      mkdir_if_not_exist './app/models/'
      mkdir_if_not_exist './app/paginations/'
      mkdir_if_not_exist './app/controllers/'

      gem_root = File.expand_path('../', __FILE__)
      generation_path = "#{gem_root}/generations"

      generate_class "#{generation_path}/model.rb.erb",
                     "./app/models/#{@options[:site]}.rb"
      generate_class "#{generation_path}/pagination.rb.erb",
                     "./app/paginations/#{@options[:site]}_pagination.rb"
      generate_class "#{generation_path}/controller.rb.erb",
                     "./app/controllers/#{@options[:site]}_controller.rb"
    end

    private

      def generate_class(from, to)
        if File.exist? to
          puts 'Skip: ' + to
          return
        end

        open(to, 'w') do |f|
          template = Tilt.new(from)
          f.puts template.render(self, site_class: @options[:site].classify)
        end
      end

      def mkdir_if_not_exist(path)
        return if File.exist? path

        require 'fileutils'
        FileUtils.mkdir_p path
      end
  end
end

