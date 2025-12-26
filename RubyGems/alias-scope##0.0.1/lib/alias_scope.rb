require "alias_scope/version"

module ActiveRecord
  class Base
    def self.alias_scope(aliases, orig_scope)
      Array(aliases).each do |_alias|
        scope _alias, proc {|*args| self.send(orig_scope, *args) }
      end
    end
  end
end
