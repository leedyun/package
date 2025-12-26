require 'optparse'
require 'logger'

class Options
  attr_accessor :options, :log
  def initialize(ops = {})
    @options = {}
    options.merge! ops
    @log = Logger.new('log.txt')
    if level = @options[:debug_level]
      @log.level = level
    else
      @log.level = Logger::DEBUG
    end
    optparse = OptionParser.new do |opts|
      opts.banner = "Usage: pub -e <environment_to_publish_to>"
      @options[:debug] = false
      opts.on( '-d', '--debug', 'Turn on program debugging' ) do |level|
        options[:debug] = true
        options[:debug_level] = level
      end
     @options[:verbose] = false
     opts.on( '-v', '--verbose', 'Output more information' ) do
       @options[:verbose] = true
     end
      @options[:environment] = 'loc'
      opts.on( '-e', '--environment ENV', 'Publish to environment ENV. REQUIRED.' ) do |env|
        options[:environment] = env
      end
      @options[:indexer_url] = nil
      opts.on( '-i', '--indexer_ulr URL', 'Submit docs to indexer with url: URL' ) do |solr_base_url|
        options[:indexer_url] = solr_base_url
      end
      @options[:source_folder] = '.'
      opts.on( '-s', '--source_folder FOLDER', 'Use FOLDER as source of artifact to deploy.') do |source_folder|
        options[:source_folder] = source_folder
      end
      opts.on( '-h', '--help', 'Display this screen' ) do
        puts opts
        exit
      end
    end
    optparse.parse!
    @log.debug "Deploying to #{options[:environment]} environment." if @options[:debug]
  end
end
