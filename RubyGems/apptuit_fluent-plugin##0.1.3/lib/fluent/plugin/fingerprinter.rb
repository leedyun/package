#
# Copyright 2017 Agilx, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/usr/bin/env ruby
#Apptuit Error Fingerprinter
require 'digest/sha1'
require 'syslog/logger'

class FingerPrinter
    LANG_PYTHON = "python"
    LANG_NODEJS = "nodejs"
    LANG_JAVA = "java"

    REASON_NOT_A_STACKTRACE = "NOT_A_STACKTRACE"
    REASON_NO_EXCEPTION_NAME = "NO_EXCEPTION_NAME"
    REASON_MULTIPLE_EXCEPTION_NAMES = "MULTIPLE_EXCEPTION_NAMES"


    def fingerprint_error(lang, reason, message)
        log = Syslog::Logger.new 'finger_printer'
        error_message = 'Error fingerprinting [lang:%s] [reason:%s] message:\n%s' % [lang, reason, message]
        log.error error_message
        return nil
    end

    def fingerprint_python(message)
            clean_message = message
            idx = clean_message.index("Traceback (most recent call last)")
            if idx == -1
                return fingerprint_error(LANG_PYTHON, REASON_NOT_A_STACKTRACE, clean_message)
            end
            clean_message = clean_message[idx..-1]
            clean_message = clean_message.gsub('---', "\n---")
            clean_message = clean_message.gsub(/---\s*$/, "")
            t = clean_message.index(/Traceback \(most recent call last\)/)
            clean_message = clean_message[t..-1]
            dup = clean_message.index("Traceback (most recent call last)", idx+1)
            if dup != nil
                clean_message = clean_message[0..dup]
            end
            check_format = clean_message.scan(/---\s/)
            if check_format.length == 0
                clean_message = clean_message.gsub("\n", "\n--- ")
            end
            matches = clean_message.scan(/---\s([a-zA-Z_]+)(:|(\s*$))/)
            if matches.length == 1
                err_name = matches[0][0]
                clean_message = clean_message.gsub(/,\s*line\s*[0-9]*\s*,/, ", line *,")
                clean_message = clean_message.gsub(/---\s*((?!File).)*(\n|$)/, '')
                clean_message = "%s--- %s" % [clean_message, err_name]
                fingerprint = Digest::SHA1.hexdigest clean_message
                stack = Array.new
                stack_matches = clean_message.scan(/---\s+File\s+"([^"]*)".*\s+in\s+([^\s]*)/)
                for stack_match in stack_matches do
                    stack << [stack_match[0], stack_match[1]]
                end
                return err_name, fingerprint, clean_message, stack
            elsif matches.length == 0
                return fingerprint_error(LANG_PYTHON, REASON_NO_EXCEPTION_NAME, message)
            else
                return fingerprint_error(LANG_PYTHON, REASON_MULTIPLE_EXCEPTION_NAMES, message)
            end
    end

    def fingerprint_nodejs(message)
          json_stack_matches = message.scan(/"stack"\s*:\s*"([^\"]*)"/)
          if json_stack_matches.length > 0
              clean_message = json_stack_matches[0].to_s
              clean_message = clean_message[2..clean_message.length-3]
              clean_message = clean_message.gsub(/\s+at\s+/, "\n--- at ")
          else
              clean_message = message.gsub('---', "\n---")
          end
          matches = clean_message.scan(/\s*at[^(]*([^)]*\.js:[0-9]+:[0-9]+)/)
          if matches.length < 1
              return fingerprint_error(LANG_NODEJS, REASON_NOT_A_STACKTRACE, clean_message)
          end
          matches = clean_message.scan(/\s*([a-zA-Z]+)(:\s|(\s*$))/)
          if matches.length > 0
              err_name = matches[0][0]
              matches = clean_message.scan(/(^|\n)---\s*at\s*(.*)/)
              lines = ""
              for parts in matches do
                  frame = parts[1].strip
                  lines = "%sat %s\n" % [lines, frame]
              end
              clean_message = "%s\n%s" % [err_name,lines]
              clean_message = clean_message.gsub(/:[0-9]+:[0-9]+/, ":*:*")
              fingerprint = Digest::SHA1.hexdigest clean_message
              stack = []
              stack_matches = clean_message.scan(/at\s+((.+)\s+\()?([^:]*).*/)
              for stack_match in stack_matches do
                  stack << [stack_match[1], stack_match[2]]
              end
              return err_name, fingerprint, clean_message, stack
          else
              return fingerprint_error(LANG_NODEJS, REASON_NO_EXCEPTION_NAME, message)
          end
    end

    def fingerprint_java(message)
            message = message.gsub(/\\n/, "\n")
            message = message.gsub(/\\t/, "\t")
            matches = message.scan(/^[ \t]*([^ \t]+)[:\r\n]/)
            if matches.length == 1
                err_name = matches[0][0]
            else
                heuristic_message = heuristic_search_java_stack_trace(message)
                if heuristic_message != nil
                    err_name = heuristic_message[3]
                    message = heuristic_message[2]
                else
                    return fingerprint_error(LANG_JAVA, REASON_NO_EXCEPTION_NAME, message)
                end
            end
            clean_message = message
            clean_message = clean_message.gsub(/\A\s*([^:\s]*).*/, '\1')
            clean_message = clean_message.gsub(/(Caused by: [^:\s]*).*/, '\1')
            clean_message = clean_message.gsub(/[ \t]*at[ \t]+([^(]+).*/, "\tat "+'\1')
            clean_message = clean_message.gsub(/at sun\.reflect\.NativeMethodAccessorImpl\.invoke0/, "\n")
            clean_message = clean_message.gsub(/at sun\.reflect\.NativeMethodAccessorImpl(\.[^.\s]+)/, 'at sun.reflect.$$MethodAccessor$$\1')
            clean_message = clean_message.gsub(/at sun\.reflect\.GeneratedMethodAccessor.*(\.[^.\s]+)/, 'at sun.reflect.$$MethodAccessor$$\1')
            clean_message = clean_message.gsub(/at com\.sun\.proxy\.\$Proxy.*\.([^.]+)/, 'at com.sun.proxy.$Proxy$$')
            clean_message = clean_message.gsub(/^((?!(Caused by:|Suppressed:|(\s*at ))).)*$/,'')
            clean_message = clean_message.gsub(/\A^/,err_name)
            clean_message = clean_message.gsub(/([\r\n]\s*[\r\n])+/, "\n").strip

            stack = Array.new
            cur_stack = Array.new
            stack_matches = clean_message.scan(/(Caused by:|Suppressed:)|(at\s+(.+)\.([^.\s]+))/)
            for stack_match in stack_matches do
                if stack_match[0]
                    stack = cur_stack + stack
                    cur_stack.clear
                else
                    cur_stack << [stack_match[2], stack_match[3]]
                end
            end
            if stack
                stack = cur_stack + stack
            else
                stack = cur_stack
            end
            fingerprint = Digest::SHA1.hexdigest clean_message
            return err_name, fingerprint, clean_message, stack
    end

    def heuristic_search_java_stack_trace(log_message)
        matches = /(^|[\r\n])((([\w_$][\w_$]*\.)*[\w_$][\w_$]*)([\r\\n]|:[^\r\\n]*).*\s*at\s+[^\s]+\(.*)/m.match(log_message)
        if matches != nil
            return matches
        else
            return nil
        end
    end
end

