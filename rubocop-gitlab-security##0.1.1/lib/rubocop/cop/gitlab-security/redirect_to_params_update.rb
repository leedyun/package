module RuboCop
  module Cop
    module GitlabSecurity
      # Check for use of redirect_to(params.update())
      #
      # Passing user params to the redirect_to method provides an open redirect
      #
      # @example
      #
      #   # bad
      #   redirect_to(params.update(action:'main'))
      #
      #   # good
      #   redirect_to(whitelist(params))
      #
      class RedirectToParamsUpdate < RuboCop::Cop::Cop
        MSG = 'Avoid using redirect_to(params.update()). Only pass whitelisted arguments into redirect_to() (e.g. not including `host`)'.freeze

        def_node_matcher :redirect_to_params_update_node, <<-PATTERN
           (send nil :redirect_to (send (send nil? :params) ${:update :merge} ...))
        PATTERN

        def on_send(node)
          return unless redirect_to_params_update_node(node)

          add_offense(node, location: :selector)
        end
      end
    end
  end
end
