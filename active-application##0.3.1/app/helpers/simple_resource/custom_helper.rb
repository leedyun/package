module SimpleResource
  module CustomHelper
    def resource_human_attributes
      human_attributes = resource_attributes - non_human_attributes
      
      if @exclude_fields
        human_attributes = human_attributes - @exclude_fields
      end

      if respond_to?("parent?")
        human_attributes = human_attributes - ["#{parent.class.name.underscore}_id"]
      end

      human_attributes
    end
  end
end

SimpleResource::BaseHelper.extend SimpleResource::CustomHelper
