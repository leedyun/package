class SubCommand < Thor
  @cli = nil
  @curr_dir = nil

  def initialize(*args)
    super
    @cli = Cnvrg::CLI.new
    @curr_dir = @cli.is_cnvrg_dir
    @config = YAML.load_file(@curr_dir + "/.cnvrg/config.yml") if @curr_dir
    @helpers = Cnvrg::OrgHelpers.new();
  end

  def self.banner(command, namespace = nil, subcommand = false)
    "#{basename}  #{command.usage}"
  end

  def self.subcommand_prefix
    self.name.gsub(%r{.*::}, '').gsub(%r{^[A-Z]}) {|match| match[0].downcase}.gsub(%r{[A-Z]}) {|match| "-#{match[0].downcase}"}
  end

  class << self
    # Hackery.Take the run method away from Thor so that we can redefine it.
    def is_thor_reserved_word?(word, type)
      return false if word == "run"
      super
    end
  end
end