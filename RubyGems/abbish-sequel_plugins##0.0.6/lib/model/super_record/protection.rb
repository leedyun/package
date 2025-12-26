module Abbish
  module Sequel
    module Plugins
      module Model
        module SuperRecord
          module Protection
            ProtectedError = Class.new(::StandardError)
            def self.configure(model, options = {})
              options = {
                  :enabled => true,
                  :feature_column_protected => :record_protected,
                  :raise_protected_message => 'Cannot destroy protected record',
              }.merge(options)

              Abbish::Sequel::Plugins::Model::SuperRecord.check_feature_column model, options[:feature_column_protected]

              model.instance_eval do
                self.record_protection_options = options
              end
            end

            module ClassMethods
              def record_protection_options=(options)
                @record_protection_options = options
              end

              def record_protection_options
                @record_protection_options
              end
            end

            module InstanceMethods

              def record_protected?
                self.class.record_protection_options[:enabled] ? send("#{self.class.record_protection_options[:feature_column_protected]}") == 1 : false
              end

              def set_record_protected
                send("#{self.class.record_protection_options[:feature_column_protected]}=", 1) if self.class.record_protection_options[:enabled]
              end

              def set_record_protected!
                if self.class.record_protection_options[:enabled]
                  set_record_protected
                  self.save
                end
              end

              def before_destroy
                super
                raise ProtectedError, self.class.record_protection_options[:raise_protected_message] if record_protected?
              end
            end
          end
        end
      end
    end
  end
end


