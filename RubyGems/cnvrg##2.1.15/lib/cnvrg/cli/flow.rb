require 'cnvrg/cli'
require 'cnvrg/data'
require 'cnvrg/task'
require 'cnvrg/flow'
require 'cnvrg/hyper'
require 'cnvrg/cli/subcommand'
require 'cnvrg/cli/task'
require 'thor'
module Cnvrg
  module Commands
    class Flow < SubCommand

      def initialize(*args)
        super
        unless @curr_dir.present?
          @cli.log_message("Not On Project Dir, exiting", Thor::Color::RED)
          exit(1)
        end
      end

      desc "flow import --file='flow.yaml'", "Import flow to the web"
      method_option :file, :type => :string, :aliases => ["-f", "--file"]
      def import()
        run_flow_internal(file: options[:file], run: false)
      end

      desc "flow run --file='flow.yaml'", "Import flow to the web"
      method_option :file, :type => :string, :aliases => ["-f", "--file"]
      def run()
        run_flow_internal(file: options[:file], run: true)
      end

      no_commands {
      def run_flow_internal(file: nil, run: false)
        if options[:file].blank?
          Cnvrg::CLI.log_message("Flow title is required for export. please use --title='Flow 1'")
          return
        end
        if not File.exists? options[:file]
          Cnvrg::CLI.log_message("Cant find file in path #{options[:file]}.")
          return
        end
        payload = YAML.safe_load(File.open(file).read)
        @project = Cnvrg::Project.new(Cnvrg::CLI.get_project_home)
        begin
          @flow, version_slug = Flows.create_flow(@project, payload, run: run)
        rescue => e
          Cnvrg::CLI.log_message("Error while validating flow: #{e.message}", 'error')
          return
        end
        Cnvrg::CLI.log_message("New flow version was created successfuly!", 'green')
        Cnvrg::CLI.log_message("you can find the flow in #{@flow.edit_version_href(version_slug)}", 'green')
      rescue => e
        Cnvrg::CLI.log_message("Failed while creating flow")
        Cnvrg::Logger.log_error(e)
      end
      }

      desc "flow export --file='flow.yaml' --title='Flow 1' --version='version 1'", "Export flow to the web"
      method_option :file, :type => :string, :aliases => ["-f", "--file"]
      method_option :title, :type => :string, :aliases => ["-t", "--title"]
      method_option :version, :type => :string, :aliases => ["-v", "--version"], :default => "latest"
      def export()
        if options[:title].blank?
          Cnvrg::CLI.log_message("Flow title is required for export. please use --title='Flow 1'", "red")
          return
        end

        @project = Cnvrg::Project.new(Cnvrg::CLI.get_project_home)
        @flow = Flows.new(options[:title], project: @project)
        filename = @flow.export(options[:version], file: options[:file])
        Cnvrg::CLI.log_message("Flow was saved successfuly to: #{filename}", 'green')
      rescue => e
        Cnvrg::CLI.log_message(e.message, 'red')
        Cnvrg::Logger.log_error(e)
      end

      # desc "task", "Running Flow tasks", :hide => true
      # subcommand 'task', Cnvrg::Commands::Task
      #
      # desc "flow verify", "verify that the flow is well formatted"
      #
      # def verify(path)
      #   unless @curr_dir.present?
      #     @cli.log_message("Cant run this command because you are not in project directory", Thor::Color::RED)
      #     return false
      #   end
      #   @flow = Cnvrg::Flows.new(@curr_dir, path)
      #   @cli.log_message("The Flow is Valid", Thor::Color::GREEN)
      # end
      #
      #
      # desc "flow run", "run a flow file"
      # def run(flow_slug)
      #   unless @curr_dir.present?
      #     @cli.log_message("Cant run this command because you are not in project directory", Thor::Color::RED)
      #     return false
      #   end
      #   @flow = Cnvrg::Flows.new(flow_slug)
      #   resp = @flow.run
      #   flow_version_href = resp["flow_version"]["href"]
      #   Cnvrg::CLI.log_message("Flow Live results: #{flow_version_href}")
      #   true
      # end
      #
      # desc "flow create", "create a flow file"
      #
      # def create
      #   title = ask("Flow Title: ")
      #   title = title.presence || "cnvrg-flow"
      #   relations = []
      #   task = ask_for_relation
      #   while task.compact.size == 2
      #     from, to = task
      #     relations << {from: from, to: to}
      #     task = ask_for_relation
      #   end
      #   start_commit = ask("Flow Starting Commit (empty will set this value to 'latest')")
      #   Cnvrg::Flows.create_flow("#{title}.flow.yaml", {title: title, relations: relations, start_commit: start_commit})
      # end
      #
      #
      # # desc "flow resolve", "Resolve flow parameters"
      # # def resolve(path)
      # #   @hyper = Cnvrg::Hyper.new(@curr_dir, path)
      # #   @hyper.resolve_params
      # # end
      # #
      #
      # private
      #
      # def init_tasks
      #   @tasks = Dir.glob("**/*.task*")
      # end
      #
      # def ask_for_relation
      #   init_tasks if @tasks.blank?
      #   to = nil
      #   from = ask_for_task("Task To Start From: [#{@tasks.join(', ')}]")
      #   to = ask_for_task("Task To Go To: [#{@tasks.join(', ')}]") if from.present?
      #   [from, to]
      # end
      #
      # def ask_for_task(text)
      #   verified = false
      #   task = nil
      #   while !verified
      #     task = ask(text)
      #     if task.blank?
      #       return nil
      #     end
      #     begin
      #       Cnvrg::Task.new(@curr_dir, path: task).verify_task
      #       verified = true
      #     rescue => e
      #     end
      #   end
      #   task
      # end
      #
      # def get_all_tasks
      #   @tasks = Dir.glob("*/**.task.yaml")
      # end
  end
end
end
