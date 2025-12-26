require 'rails/generators/migration'

module TelegramNotifications
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    desc "Generates files for TelegramNotifications gem"

    def self.orm
      Rails::Generators.options[:rails][:orm]
    end

    def self.source_root
      File.join(File.dirname(__FILE__), 'templates', (orm.to_s unless orm.class.eql?(String)) )
    end

    def self.orm_has_migration?
      [:active_record].include? orm
    end

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def create_migration_file
      if self.class.orm_has_migration?
        migration_template 'migration.rb', 'db/migrate/create_telegram_notifications.rb'
      end
    end

    def copy_initializer
      copy_file 'telegram_notifications.rb', 'config/initializers/telegram_notifications.rb'
      copy_file 'subscribe_controller.rb', 'app/controllers/subscribe_controller.rb'
      copy_file 'telegram_user.rb', 'app/models/telegram_user.rb'
    end
  end
end
