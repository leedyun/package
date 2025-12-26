require 'active_model'
require 'active_model/validations/at_least_one_existence_validator'
require 'active_support/i18n'

module AtLeastOneExistenceValidator
end

I18n.load_path += Dir[File.join File.dirname(__FILE__), '..', 'locales', '*.yml']
