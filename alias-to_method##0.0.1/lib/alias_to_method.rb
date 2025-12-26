require "alias_to_method/version"

module AliasToMethod
  def self.convert(input)
		input = input.gsub(':', '')
		input = input.gsub(' ', '')
		input = input.split(',')

		input.each do |i|
			puts "def #{i}\n   @attrs.#{i}\nend"
		end
  end
end
