require File.dirname(__FILE__) + '/super_record/version'
require File.dirname(__FILE__) + '/super_record/protection'
require File.dirname(__FILE__) + '/super_record/timestamp'

module Abbish
  module Sequel
    module Plugins
      module Model
        module SuperRecord
          FeatureColumnError = Class.new(::StandardError)
          def check_feature_column(model, column)
            raise FeatureColumnError, "Feature column #{column} cannot be found" if !model.columns.include? column
          end

          module_function :check_feature_column
        end
      end
    end
  end
end
