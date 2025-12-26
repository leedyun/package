# frozen_string_literal: true

require 'json'

module GitlabQuality
  module TestTooling
    module SystemLogs
      module Finders
        class JsonLogFinder
          def initialize(base_path, file_path)
            @base_path = base_path
            @file_path = file_path
          end

          def find(correlation_id)
            log_file_path = "#{@base_path}/#{@file_path}"
            logs = []

            if File.exist?(log_file_path) && !correlation_id.nil?
              File.foreach(log_file_path) do |line|
                begin
                  json_line = JSON.parse(line, symbolize_names: true)
                rescue JSON::ParserError
                  Runtime::Logger.debug("JsonLogFinder#find attempted to parse invalid JSON: #{line}")

                  next
                end

                if (json_line[:correlation_id])&.casecmp?(correlation_id)
                  normalized_line = normalize_keys(json_line)
                  logs << new_log(normalized_line)
                end
              end
            end

            logs
          end

          def new_log(_data)
            raise 'abstract method new_log must be defined!'
          end

          private

          def normalize_keys(json_line)
            normalized_hash = {}

            json_line.each_key do |old_key|
              key_string = old_key.to_s

              if key_string.include?('.')
                normalized_key = key_string.tr('.', '_').to_sym
                normalized_hash[normalized_key] = json_line[old_key]
              else
                normalized_hash[old_key] = json_line[old_key]
              end
            end

            normalized_hash
          end
        end
      end
    end
  end
end
