module <%= name.camelize %>Helper

    def publish(model, options = {})

      class_name = model.class.to_s.underscore

      url_options = { :id => model.id, :type => class_name }

      url_options[:url] = options[:url] if options[:url].present?

      link_to(I18n.t("helpers.#{class_name}.publish"),<%= name %>_publish_path(url_options),:method=>:put)
    end

    def unpublish(model, options = {})

      class_name = model.class.to_s.underscore 

      url_options = { :id => model.id, :type => class_name }

      url_options[:url] = options[:url] if options[:url].present?

      link_to(I18n.t("helpers.#{class_name}.unpublish"), <%= name %>_unpublish_path(url_options), :method=>:put)
    end

    def toggle_publish(model, options= {})
      model.published ? unpublish(model, options) : publish(model, options)
    end

end
