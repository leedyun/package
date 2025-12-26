module ApplicationModule
  # You need to put this in controllers in your module:
  #
  #     extend ApplicationModule::Controller
  #
  # It makes Rails find the views inside your module directory.
  module Controller
    def self.extended(controller_class)
      app_module_name = controller_class.name[%r{^[A-Za-z][A-Za-z0-9]*}]
      app_module = const_get(app_module_name)
      controller_class.instance_eval do
        prepend_view_path app_module.view_path

        protected

        # Overriding AbstractController::ViewPaths#_prefixes
        # to make it find the view 'login/new' instead 'module_name/login/new'
        # Based on rails-3.2.11
        define_method :_prefixes do
          @_prefixes ||= begin
            parent_prefixes = self.class.parent_prefixes
            parent_prefixes.dup.unshift(controller_path.sub(%r{#{app_module_name.underscore}/}, ''))
          end
        end
      end
    end
  end
end
