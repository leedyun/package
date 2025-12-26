module ActionDispatch::Routing

    class Mapper

        def acts_as_publicable(name)
           base_route_name = name.to_s.underscore.pluralize
           put "/#{base_route_name}/:id/publish/:type" => "#{base_route_name}#publish", :as => "#{base_route_name}_publish"
           put "/#{base_route_name}/:id/unpublish/:type" => "#{base_route_name}#unpublish", :as => "#{base_route_name}_unpublish"
        end
        
    end
    
end
