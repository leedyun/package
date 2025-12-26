# DeepTraversal provides traverse possibility of Hashes
# Can handle Hash objects with deep nesting, or other nested objects that can be dug deeper (e.g. Array)
module Blinkist
  module AirbrakeScrubber

    class DeepTraversal
      def initialize(source)
        @source = source
      end

      def traverse(&block)
        recursive_traverse(@source, &block)
      end

      private

      def recursive_traverse(input, &block)
        case input
        when Array
          input.map { |i| recursive_traverse(i, &block) }

        when Hash
          Hash[input.map { |key, value|

            # Go deeper for things that are not simple objects
            case value
            when Array, Hash
              [ key, recursive_traverse(value, &block) ]
            else
              [ key, block.call(key, value) ]
            end

          }]
        else
          input
        end
      end
    end

  end
end
