module ActiveValidator
  class Base

    if ActiveRecord::VERSION::MAJOR >= 4
      include ActiveModel::Validations
    elsif ActiveRecord::VERSION::MAJOR >= 3
      include ActiveRecord::Validations
    end

    attr_accessor :safe_params

    def initialize(params)
      @safe_params = delete_unsafe_params(params)
      setup_attributes(safe_params)
    end

    ###################
    #= Class methods =#
    ###################
    def self.safe_params(*args)
      @@safe_params = args
    end

    ######################
    #= Instance methods =#
    ######################
    def delete_unsafe_params(params)
      params.permit(*@@safe_params)
    end

    def setup_attributes(params)
      params.each do |k,v|
        self.class.send(:attr_accessor, k)
        instance_variable_set(:"@#{k}", v)
      end
    end

    def error_messages
      { error: errors.full_messages.uniq } unless self.valid?
    end

    #####################################
    #= Methods to handle compatibility =#
    #####################################
    def new_record?
      false
    end
  end
end
