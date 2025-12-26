module Abbish
  module Sequel
    module Plugins
      module Model
        module SuperRecord
          module Version
            def self.configure(model, options = {})
              options = {
                  :enabled => true,
                  :feature_column_version => :record_version,
              }.merge(options)

              Abbish::Sequel::Plugins::Model::SuperRecord.check_feature_column model, options[:feature_column_version]

              model.instance_eval do
                self.record_version_options = options
              end
            end

            module ClassMethods
              def record_version_options=(options)
                @record_version_options = options
              end

              def record_version_options
                @record_version_options
              end
            end

            module InstanceMethods

              def before_create

                send("#{self.class.record_version_options[:feature_column_version]}=", _get_version) if self.class.record_version_options[:enabled]
                super
              end

              def before_update
                send("#{self.class.record_version_options[:feature_column_version]}=", _get_version) if self.class.record_version_options[:enabled] if self.modified?
                super
              end

              private

              def _get_version
                return Digest::MD5.hexdigest Time.now.to_f.to_s
              end
            end
          end
        end
      end
    end
  end
end
