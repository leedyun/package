require "attribute_normalizer/extras"
require "rspec"
require "simplecov"
require "pry"

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/vendor/"
end
