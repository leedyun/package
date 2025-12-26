namespace :custom_logs do

  desc "dump users to custom logs"
  task :dump_users => :environment do

    logger = Logger.new(STDOUT)
    my_dump_class_string = (ENV['dump_class'] || 'User').classify

    begin
      my_dump_class = my_dump_class_string.constantize
    rescue
      my_dump_class = nil
    end

    if my_dump_class
      CustomLogs::Logger.dump_users(my_dump_class)
    else
      logger.error "Error: Your dump class '#{my_dump_class_string}' doesn't exists"
    end

  end

end