# frozen_string_literal: true

begin
  require 'fakeredis'
rescue LoadError
  require 'redis'
end

%w[active_object active_redis_db active_support/core_ext/time].each do |file_name|
  require file_name
end

%w[version base].each do |file_name|
  require "active_redis_stats/#{file_name}"
end

%w[base set get].each do |file_name|
  %w[count rank].each do |dir_name|
    require "active_redis_stats/#{dir_name}/#{file_name}"
  end
end
