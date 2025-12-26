module RuboCop
  module Cop
    module GitlabSecurity
      # Checks for the use of `public_send`, `send`, and `__send__` methods.
      #
      # If passed untrusted input these methods can be used to execute arbitrary
      # methods on behalf of an attacker.
      #
      # @example
      #
      #   # bad
      #   myobj.public_send("#{params[:foo]}")
      #
      #   # good
      #   case params[:foo].to_s
      #   when 'choice1'
      #     items.choice1
      #   when 'choice2'
      #     items.choice2
      #   when 'choice3'
      #     items.choice3
      #   end
      class PublicSend < RuboCop::Cop::Cop
        MSG = 'Avoid using `%s`.'.freeze

        def_node_matcher :send?, <<-PATTERN
          (send _ ${:send :public_send :__send__} ...)
        PATTERN

        def on_send(node)
          send?(node) do |match|
            next unless node.arguments?

            add_offense(node, location: :selector, message: format(MSG, match))
          end
        end
      end
    end
  end
end
