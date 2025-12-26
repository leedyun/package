module ArchiveUploader
  AUTH_METHODS = [:basic]
  class CLIError < StandardError; end
  class CLI
    # return a structure describing the options
    def self.parse(args)
      options = OpenStruct.new
      options.directories = []
      options.verbose = false
      options.auth = OpenStruct.new

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: archive_uploader [options]"

        opts.separator ""
        opts.separator "Specific options:"

        # Directory
        opts.on("-d", "--directory PATH",
                "Add directory to archive") do |dir|
          options.directories << dir
        end

        # List of arguments.
        opts.on("-D x,y,z", Array, "Add list of files/directories") do |list|
          options.directories += list
        end

        # Optional argument; auth method
        opts.on("-a", "--authmethod [TYPE]",
                "Set auth method",
                "  (default disabled)") do |method|

          raise CLIError unless AUTH_METHODS.include?(method.to_sym)
          # Screw ruby object defining #method
          options.auth._method = method.to_sym
        end

        # Optional argument; auth user
        opts.on("-u", "--authuser [USER]",
                "Set auth user",
                "  (default none)") do |user|
          options.auth.user = user
        end

        # Optional argument; auth password
        opts.on("-p", "--authpassword [PASSWORD]",
                "Set auth password",
                "  (default none)") do |password|
          options.auth.password = password
        end

        # Verbose
        opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
          options.verbose = v
        end

        opts.separator ""
        opts.separator "Common options:"

        # No argument, shows at tail.  This will print an options summary.
        # Try it and see!
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        # Another typical switch to print the version.
        opts.on_tail("--version", "Show version") do
          puts ArchiveUploder::VERSION.join('.')
          exit
        end
      end

      opt_parser.parse!(args)
      options
    end
  end
end
