module Abbish
  module Sequel
    module Plugins
      module Model
        module SuperRecord
          module Timestamp
            def self.configure(model, options = {})
              options = {
                  :enabled => true,
                  :feature_column_created_time => :record_created_time,
                  :feature_column_updated_time => :record_updated_time,
              }.merge(options)

              Abbish::Sequel::Plugins::Model::SuperRecord.check_feature_column model, options[:feature_column_created_time]
              Abbish::Sequel::Plugins::Model::SuperRecord.check_feature_column model, options[:feature_column_updated_time]

              model.instance_eval do
                self.record_timestamp_options = options
              end
            end

            module ClassMethods
              def record_timestamp_options=(options)
                @record_timestamp_options = options
              end

              def record_timestamp_options
                @record_timestamp_options
              end
            end

            module InstanceMethods

              def before_create
                send("#{self.class.record_timestamp_options[:feature_column_created_time]}=", _get_time) if self.class.record_timestamp_options[:enabled]
                super
              end

              def before_update
                send("#{self.class.record_timestamp_options[:feature_column_updated_time]}=", _get_time) if self.class.record_timestamp_options[:enabled] if self.modified?
                super
              end

              private

              def _get_time
                return Time.now
              end
            end
          end
        end
      end
    end
  end
end



