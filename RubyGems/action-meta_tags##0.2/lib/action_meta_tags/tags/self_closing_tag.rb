module ActionMetaTags
  module Tags
    class SelfClosingTag
      def initialize(attrs, &block)
        @attrs    = attrs
        @renderer = block
      end

      def render(view, object)
        fail NotImplementedError
      end

      protected

      attr_reader :renderer, :attrs
    end
  end
end
