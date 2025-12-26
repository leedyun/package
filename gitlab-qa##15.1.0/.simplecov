# frozen_string_literal: true

require "simplecov-cobertura"

SimpleCov.configure do
  formatter SimpleCov::Formatter::CoberturaFormatter
  enable_coverage :branch
  add_filter ["/spec/", "/vendor/"]
end
