module ActionMetaTags
  module Tags
    class Meta < SelfClosingTag
      def render(view, object)
        content = object.instance_exec(&renderer)
        view.tag(:meta, attrs.merge(content: content))
      end
    end
  end
end
