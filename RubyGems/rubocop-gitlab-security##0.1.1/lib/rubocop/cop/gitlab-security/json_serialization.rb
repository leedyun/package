module RuboCop
  module Cop
    module GitlabSecurity
      # Checks for `to_json` / `as_json` without whitelisting via `only`.
      #
      # Either method called on an instance of a `Serializer` class will be
      # ignored. Associations included via `include` are subject to the same
      # rules.
      #
      # @example
      #
      #   # bad
      #   render json: @user.to_json
      #   render json: @user.to_json(except: %i[password])
      #   render json: @user.to_json(
      #     only: %i[username],
      #     include: [:identities]
      #   )
      #
      #   # acceptable
      #   render json: UserSerializer.new.to_json
      #
      #   # good
      #   render json: @user.to_json(only: %i[name username])
      #   render json: @user.to_json(
      #     only: %i[username],
      #     include: { identities: { only: %i[provider] } }
      #   )
      #
      # See https://gitlab.com/gitlab-org/gitlab-ce/issues/29661
      class JsonSerialization < RuboCop::Cop::Cop
        MSG = "Don't use `%s` without specifying `only`".freeze

        # Check for `to_json` sent to any object that's not a Hash literal or
        # Serializer instance
        def_node_matcher :json_serialization?, <<~PATTERN
          (send !{nil? hash #serializer?} ${:to_json :as_json} $...)
        PATTERN

        # Check if node is a `only: ...` pair
        def_node_matcher :only_pair?, <<~PATTERN
          (pair (sym :only) ...)
        PATTERN

        # Check if node is a `include: {...}` pair
        def_node_matcher :include_pair?, <<~PATTERN
          (pair (sym :include) (hash $...))
        PATTERN

        # Check for a `only: [...]` pair anywhere in the node
        def_node_search :contains_only?, <<~PATTERN
          (pair (sym :only) (array ...))
        PATTERN

        # Check for `SomeConstant.new`
        def_node_search :constant_init, <<~PATTERN
          (send (const nil? $_) :new ...)
        PATTERN

        def on_send(node)
          matched = json_serialization?(node)
          return unless matched

          @_has_top_level_only = false
          @method = matched.first

          if matched.last.nil? || matched.last.empty?
            # Empty `to_json` call
            add_offense(node, location: :selector, message: format_message)
          else
            check_arguments(node, matched)
          end
        end

        private

        def format_message
          format(MSG, @method)
        end

        def serializer?(node)
          constant_init(node).any? { |name| name.to_s.end_with?('Serializer') }
        end

        def check_arguments(node, matched)
          options = matched.last.first

          # If `to_json` was given an argument that isn't a Hash, we don't
          # know what to do here, so just move along
          return unless options.hash_type?

          options.each_child_node do |child_node|
            check_pair(child_node)
          end

          return unless requires_only?

          # Add a top-level offense for the entire argument list, but only if
          # we haven't yet added any offenses to the child Hash values (such
          # as `include`)
          add_offense(node.children.last, location: :expression, message: format_message)
        end

        def check_pair(pair)
          if only_pair?(pair)
            @_has_top_level_only = true
          elsif include_pair?(pair)
            includes = pair.value

            includes.each_child_node do |child_node|
              next if contains_only?(child_node)

              add_offense(child_node, location: :expression, message: format_message)
            end
          end
        end

        def requires_only?
          return false if @_has_top_level_only

          offenses.count.zero?
        end
      end
    end
  end
end
