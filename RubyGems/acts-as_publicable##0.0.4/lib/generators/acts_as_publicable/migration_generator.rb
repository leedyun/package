module ActsAsPublicable
    module Generators

        class MigrationGenerator < Rails::Generators::NamedBase
            include Rails::Generators::Migration
            source_root File.expand_path('../templates', __FILE__)

            def manifest
                migration_template 'migration.rb', "db/migrate/add_published_to_#{table_name}"
            end

            def self.next_migration_number(path)
                Time.now.utc.strftime("%Y%m%d%H%M%S")
            end

        end

    end
end
