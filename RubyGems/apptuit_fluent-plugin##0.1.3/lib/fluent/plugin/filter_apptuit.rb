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

require 'fluent/plugin/filter'
require 'digest/sha1'
require 'fluent/plugin/fingerprinter.rb'
require 'syslog/logger'

module Fluent::Plugin
    class ApptuitFilter < Filter
      Fluent::Plugin.register_filter("apptuit", self)

      config_param :lang, :string
      config_param :syslog, :bool, default: false
      config_param :error_msg_tag, :string, default: 'message' 

      def get_decoded_message(message)
	  message = message.gsub(/#([0-9]{3})/) {$1.oct.chr}    	 
        return message 
      end

      def filter(tag, time, record)
       begin
        fingerprint_object = FingerPrinter.new()
        if @lang.downcase == 'java'
	  if record.key?(@error_msg_tag)
            if syslog
              message = get_decoded_message(record[@error_msg_tag])
	    else
              message = record[@error_msg_tag]
            end
	    err_name, fingerprint, essence, stack = fingerprint_object.fingerprint_java(message)
	    if err_name != nil
               record['error_fingerprint'] = fingerprint 
	       record['exception'] = err_name
	    end
      	  end
        elsif @lang.downcase == 'python'
	   if record.key?(@error_msg_tag)
            if syslog
              message = get_decoded_message(record[@error_msg_tag])
	    else
              message = record[@error_msg_tag]
            end
	    err_name, fingerprint, essence, stack = fingerprint_object.fingerprint_python(message)
            if err_name != nil
               record['error_fingerprint'] = fingerprint 
	       record['exception'] = err_name
	    end
      	   end
        elsif @lang.downcase == 'nodejs'
	  if record.key?(@error_msg_tag)
            if syslog
              message = get_decoded_message(record[@error_msg_tag])
	    else
              message = record[@error_msg_tag]
            end
	    err_name, fingerprint, essence, stack = fingerprint_object.fingerprint_nodejs(message)
            if err_name != nil
               record['error_fingerprint'] = fingerprint
	       record['exception'] = err_name
	    end
	  end
        else
	   return record
        end
       rescue
	return record
       end
       record
      end
   end
end
