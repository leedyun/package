#
# A String extension for ActsAsExplorable
#
class String
  # Converts the String into a Hash for ActsAsExplorable.
  #
  # == Returns:
  # A Hash providing 2 keys:
  # - <tt>:values</tt> holds the search text values
  # - <tt>:params</tt> holds parameters (fields) to search in
  #
  # @example
  #   query = "Foo Bar in:name,body sort:created_at-asc"
  #   query.to_acts_as_explorable
  #   # => {:values=>["Foo", "Bar"], :params=>{:in=>["name", "body"], :sort=>["created_at-asc"]}}
  #
  # @param keys [Array<String, Symbol>, nil] Array of accepted keys
  #
  # @return [Hash] Converted query
  def to_acts_as_explorable(*keys)
    return nil if self.blank?
    ActsAsExplorable::Parser.transform(self, *keys)
  end
end
