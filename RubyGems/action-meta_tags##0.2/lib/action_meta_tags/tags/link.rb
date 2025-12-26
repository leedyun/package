module ActionMetaTags
  module Tags
    class Link < SelfClosingTag
      def render(view, object)
        href = object.instance_exec(&renderer)
        view.tag(:link, attrs.merge(href: href))
      end
    end
  end
end
