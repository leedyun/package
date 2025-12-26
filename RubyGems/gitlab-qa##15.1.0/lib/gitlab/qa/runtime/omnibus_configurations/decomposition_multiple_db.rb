# frozen_string_literal: true

module Gitlab
  module QA
    module Runtime
      module OmnibusConfigurations
        class DecompositionMultipleDb < Default
          DATABASE_EXISTENCE_CHECK_COMMAND = <<~CMD.chomp
            gitlab-psql -d gitlabhq_production_ci -c 'select 1' 2>1 > /dev/null
          CMD

          SCHEMA_EXISTENCE_CHECK_COMMAND = <<~CMD.chomp
            gitlab-psql -d gitlabhq_production_ci -c "select schema_name from information_schema.schemata where schema_name = 'gitlab_partitions_dynamic'" | grep -q gitlab_partitions_dynamic
          CMD

          def configuration
            # HACK: commenting commands out as these commands should be run *after* the first
            # reconfiguration (see first command in #exec_commands)
            <<~OMNIBUS
              #gitlab_rails['databases']['main']['enable'] = true
              #gitlab_rails['databases']['ci']['enable'] = true
              #gitlab_rails['databases']['ci']['db_database'] = 'gitlabhq_production_ci'
            OMNIBUS
          end

          def exec_commands
            [
              "sed -i 's/#gitlab_rails/gitlab_rails/g' /etc/gitlab/gitlab.rb",
              "gitlab-ctl reconfigure",
              # Create database only if it does not exist.
              "#{DATABASE_EXISTENCE_CHECK_COMMAND} || gitlab-psql -c 'create database gitlabhq_production_ci owner gitlab'",
              "gitlab-psql -d gitlabhq_production_ci -c 'create extension if not exists btree_gist'",
              "gitlab-psql -d gitlabhq_production_ci -c 'create extension if not exists pg_trgm'",
              # Load schema only if it does not exist.
              "#{SCHEMA_EXISTENCE_CHECK_COMMAND} || DISABLE_DATABASE_ENVIRONMENT_CHECK=1 gitlab-rake db:schema:load:ci",
              "gitlab-ctl restart"
            ].freeze
          end
        end
      end
    end
  end
end
