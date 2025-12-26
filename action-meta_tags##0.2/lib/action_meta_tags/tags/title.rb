module ActionMetaTags
  module Tags
    class Title
      def initialize(&block)
        @renderer = block
      end

      def render(view, object)
        content = object.instance_exec(&renderer)
        view.content_tag(:title, content)
      end

      private

      attr_reader :renderer
    end
  end
end
