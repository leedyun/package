# frozen_string_literal: true

module Gitlab
  module Triage
    module ExpandCondition
      class Expansion
        # @pattern describes how we're looking for the pattern, and
        # @compile is a block which should compile the scanned data
        # into a list of results.
        #
        # Please see the comments for #perform to see actual example.
        def initialize(pattern, &compile)
          @pattern = pattern
          @compile = compile
        end

        # This method will take a list of strings, which contains
        # some kind of pattern, described by @pattern and expand them
        # into each possible matches via @compile. For example,
        # suppose @pattern is:
        #
        #     /\{(\d+)\.\.(\d+)\}/
        #
        # And @compile is:
        #
        #     do |(lower, upper)|
        #       Integer(lower)..Integer(upper)
        #     end
        #
        # And the input is:
        #
        # * a:{0..1}
        # * b:{2..3}
        # * c
        #
        # The result would be:
        #
        # * * a:0
        #   * b:2
        #   * c
        # * * a:0
        #   * b:3
        #   * c
        # * * a:1
        #   * b:2
        #   * c
        # * * a:1
        #   * b:3
        #   * c
        #
        # We get this by picking the 1st number from the 1st string,
        # which is 0 from "a:{0..1}", and the 1st number from the
        # 2nd string, which is 2 from "b:{2..3}", and since the 3rd
        # string is just a fixed string, we just pick it.
        #
        # This way we have the first possible match, that is:
        #
        # * a:0
        # * b:2
        # * c
        #
        # Then we repeat the process by picking the next number for the
        # next possible match, starting from the least significant
        # string, which is c, but there's nothing more to pick. Then we
        # go to the next one, which will be the 2nd string: "b:{2..3}",
        # and we pick the 2nd number for it: 3. Since we have a new pick,
        # we have a new possible match:
        #
        # * a:0
        # * b:3
        # * c
        #
        # Again we repeat the process, and 2nd string doesn't have more
        # choices therefore we need to go to the 1st string now. When
        # this happens, we'll need to reset the picks from the previous
        # string, thus 2nd string will go back to 2. The next number for
        # the 1st string is 1, and then we form the new match:
        #
        # * a:1
        # * b:2
        # * c
        #
        # The next step will be the last match by picking the next number
        # from the 2nd string again: 3, and we get:
        #
        # * a:1
        # * b:3
        # * c
        #
        # The method will stop here because it had walked through all the
        # possible combinations. The total number of results is the product
        # of numbers of sequences.
        #
        # Note that a string can contain multiple sequences, and it will
        # also walk through them one by one. For example, given:
        #
        # * a:{0..1}:{2..3}
        # * c
        #
        # We'll get:
        #
        # * * a:0:2
        #   * c
        # * * a:0:3
        #   * c
        # * * a:1:2
        #   * c
        # * * a:1:3
        #   * c
        def perform(strings)
          expanded_strings =
            strings.map(&:strip).map(&method(:expand_patterns))

          product_of_all(expanded_strings)
        end

        # This method returns the product of list of lists. For example,
        # giving it [%w[a:0 a:1], %w[b:2 b:3], %w[c]] will return:
        #
        # [%w[a:0 b:2 c], %w[a:0 b:3 c], %w[a:1 b:2 c], %w[a:1 b:3 c]]
        def product_of_all(expanded_strings)
          expanded_strings.first.product(*expanded_strings.drop(1))
        end

        # This method expands the string from the sequences. For example,
        # giving it "a:{0..1}:{2..3}" will return:
        #
        # %w[
        #   a:0:2
        #   a:0:3
        #   a:1:2
        #   a:1:3
        # ]
        def expand_patterns(string)
          expand(string, scan_patterns(string))
        end

        # This method extracts the sequences from the string. For example,
        # giving it "a:{0..1}:{2..3}" will return:
        #
        # [0..1, 2..3]
        def scan_patterns(string)
          string.scan(@pattern).map(&@compile)
        end

        # This recursive method does the heavy lifting. It substitutes the
        # sequence patterns in a string with a picked number from the
        # sequence, and collect all the results. Here's an example:
        #
        # expand("a:{0..1}:{2..3}", [0..1, 2..3])
        #
        # This means that we want to pick the numbers from the sequences,
        # and fill them back to the string containing the pattern in the
        # respective order. We don't care which pattern it is because
        # the order should have spoken for it. The result will be:
        #
        # %w[
        #   a:0:2
        #   a:0:3
        #   a:1:2
        #   a:1:3
        # ]
        #
        # We start by picking the first sequence, which is 0..1 here. We
        # want all the possible picks, thus we flat_map on it, substituting
        # the first pattern with the picked number. This means we get:
        #
        # "a:0:{2..3}"
        #
        # For the first iteration. Before we jump to the next pick from the
        # sequence, we recursively do this again on the current string,
        # which only has one sequence pattern left. It will be called like:
        #
        # expand("a:0:{2..3}", [2..3])
        #
        # Because we also dropped the first sequence we have already used.
        # On the next recursive call, we don't have any sequences left,
        # therefore we just return the current string: "a:0:2".
        #
        # Flattening the recursion, it might look like this:
        #
        # (0..1).flat_map do |x|
        #   (2..3).flat_map do |y|
        #     "a:{0..1}:{2..3}".sub(PATTERN, x.to_s).sub(PATTERN, y.to_s)
        #   end
        # end
        #
        # So here we could clearly see that we go deep first, substituting
        # the least significant pattern first, and then go back to the
        # previous one, until there's nothing more to pick.
        def expand(string, items)
          if items.empty?
            [string]
          else
            remainings = items.drop(1)

            items.first.flat_map do |item|
              expand(string.sub(@pattern, item.to_s), remainings)
            end
          end
        end
      end
    end
  end
end
