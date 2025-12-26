module Cnvrg
  module Commands
    class Task < SubCommand

      def initialize(*args)
        super
        unless @curr_dir.present?
          @cli.log_message("Not On Project Dir, exiting", Thor::Color::RED)
          exit(1)
        end
      end

      desc "flow task verify", "verify that the task is well formatted"
      def verify(path)
        unless @curr_dir.present?
          @cli.log_message("Cant run this command because you are not in project directory", Thor::Color::RED)
          return false
        end
        @task = Cnvrg::Task.new(@curr_dir, path: path)
        begin
          @task.verify_task
        rescue StandardError => e
          @cli.log_message("An error during parsing task: #{e.message}", Thor::Color::RED)
          @cli.log_error(e)
          return false
        rescue => e
          @cli.log_error(e)
          return false
        end
        @cli.log_message("The task verified successfuly", Thor::Color::GREEN)
        return @task
      end


      desc "flow task create", "Creates new task"
      def create
        @project = Cnvrg::Project.new(@curr_dir)

        task = {}
        task[:title] = ask("Task title", Thor::Color::GREEN)
        task[:type] = ask("Task Type?", Thor::Color::GREEN, :limited_to => ["exec", "data", "library", "deploy"])
        case task[:type]
        when "exec"
          task[:cmd] = ask("Command to run", Thor::Color::GREEN)
          task[:params], task[:params_path] = ask_for_params
          task[:machine] = ask_for_machine
        when "data"
          task[:dataset] = ask("Dataset slug", Thor::Color::GREEN)
          task[:query] = ask("Dataset query", Thor::Color::GREEN)
        when "library"
          task[:library] = ask("Library Slug", Thor::Color::GREEN)
          task[:params], task[:params_path] = ask_for_params
          task[:machine] = ask_for_machine
        when "deploy"
          task[:cmd] = ask("Command to run", Thor::Color::GREEN)
          task[:function] = ask("Function to run", Thor::Color::GREEN)
        end
        @task = Cnvrg::Task.new(@curr_dir, content: task)
        @task.save
        @cli.log_message("Task #{@task.title} Saved Successfuly", Thor::Color::GREEN)
      end


      desc "flow task run", "Running specific task"
      def run(path)
        begin
          path = "#{path}.task.yaml" unless path.end_with? '.task.yaml'
          @task = Cnvrg::Task.new(@curr_dir, path: path)
          url = @task.run
          @cli.log_message("Task: #{@task.title} is running, you can track its performance on #{url}", Thor::Color::GREEN)
        rescue => e
          @cli.log_message(e.message, Thor::Color::RED)
          @cli.log_error(e)
        end
      end

      private

      def ask_for_params
        params = []
        param_key = ask("Param key: (enter for continue)", Thor::Color::GREEN)
        while param_key.present?
          param_value = ask("#{param_key} value: (seperated by commas)", Thor::Color::GREEN)
          params << {key: param_key, value: param_value}
          param_key = ask("Param key: (enter for continue)", Thor::Color::GREEN)
        end
        if params.blank?
          params_path = ask("Params from file: ")
          if params_path.present?
            while params_path.present? and !File.exists? params_path
              params_path = ask("Cant find file, please write it again.")
            end
          end
        end
        return params, params_path
      end

      def ask_for_machine
        options = {}
        all_machines = @project.get_machines
        options[:limited_to] = all_machines if all_machines.present?
        ask("Kind of machine to execute on?", Thor::Color::GREEN, options).presence || "medium"
      end


      def on_project
        unless @curr_dir.present?
          @cli.log_message("Cant run this command because you are not in project directory", Thor::Color::RED)
          return false
        end
      end


    end
  end
end