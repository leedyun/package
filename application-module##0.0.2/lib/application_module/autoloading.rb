require 'active_support/inflector'
module ApplicationModule::Autoloading
  def autoload_file(filepath)
    klass_name = filepath[%r{([^/]+)\.rb$}, 1].camelize
    autoload klass_name.to_sym, filepath
  end

  def autoload_without_namespacing dirnames
    @autoload_without_namespacing_dirs ||= []
    Array(dirnames).each do |dirname|
      @autoload_without_namespacing_dirs << dirname
      Dir[path.join(dirname, "*_#{ActiveSupport::Inflector.singularize(dirname)}.rb")].each do |p|
        autoload_file(p)
      end
      Dir[path.join(dirname, "*.rb")].each do |p|
        autoload_file(p)
      end
    end
  end

  # Overrides const_missing in ActiveSupport::Dependencies
  def const_missing(const_name)
    filename = const_name.to_s.underscore
    dirs = [nil] + (@autoload_without_namespacing_dirs || [])
    dirs.each do |dir|
      filepath = path.join(*([dir, "#{filename}.rb"].compact))
      if File.exists? filepath
        load filepath.to_s
        return const_get(const_name)
      end
    end
    super
  end
end

