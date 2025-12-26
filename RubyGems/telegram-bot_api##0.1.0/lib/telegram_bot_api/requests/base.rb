module TelegramBotApi
  module Requests
    module Base

      def self.included(base)
        base.include InstanceMethods
        base.extend  ClassMethods
        base.class_eval { attr_accessor *self.all_arguments }
      end

      module InstanceMethods

        def to_json
          self.class.all_arguments.inject({}) do |memo, argument|
            memo.merge!({ argument => self.public_send(argument) })
          end
        end

        def valid?
          errors.empty?
        end

        def errors
          self.class.mandatory_arguments.select do |argument|
            self.public_send(argument).nil?
          end
        end

        #For convenience

        def endpoint_url
          self.class.endpoint_url
        end

        def verb
          self.class.verb
        end

        private

        def build_arguments(arguments)
          self.class.all_arguments.each do |argument|
            instance_variable_set("@#{argument}", arguments[argument])
          end
        end
      end

      module ClassMethods
        def all_arguments
          mandatory_arguments + optional_arguments
        end
      end
    end
  end
end
