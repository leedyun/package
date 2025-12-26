require 'netrc'
require 'faraday'
require 'json'
require 'fileutils'
require 'cnvrg/helpers'
require 'logger'

module Cnvrg
    class API
        USER_AGENT       = "CnvrgCLI/#{Cnvrg::VERSION}"
        ENDPOINT_VERSION = 'v1'

        def self.get_api
            home_dir = File.expand_path('~')
            config = ""
            begin
                if File.exist? home_dir+"/.cnvrg/config.yml"
                    config = YAML.load_file(home_dir+"/.cnvrg/config.yml")
                else
                    return "https://app.cnvrg.io/api"
                end

            rescue
                return "https://app.cnvrg.io/api"
            end
            if !config or config.empty? or config.to_h[:api].nil?
                return "https://app.cnvrg.io/api"
            else
              return config.to_h[:api]
            end
        end
        def self.request(resource, method = 'GET', data = {}, parse_request = true)
            resource = URI::encode resource

            # We need to remoe all double slashes from the url to work with the proxy
            resource = resource.gsub(/[\/]{2,}/, "/").gsub("https:/", "https://").gsub("http:/", "http://")

            begin
                n = Netrc.read
            rescue => e
            end

            # Make sure there is an entry for the Acquia API before generating the
            # requests.
            if n['cnvrg.io'].nil?
                puts 'You\'re not logged in'
                puts 'Please log in via `cnvrg login`'
                return
            end

            @user, @pass = n[Cnvrg::Helpers.netrc_domain]
            begin
                if !Helpers.is_verify_ssl

                    conn = Faraday.new "#{endpoint_uri}", :ssl => {:verify => false}
                else
                    conn = Faraday.new "#{endpoint_uri}"
                end
            conn.headers['Auth-Token'] = @pass
            conn.headers['Authorization'] = "CAPI #{@pass}"
            conn.headers['User-Agent'] = "#{Cnvrg::API::USER_AGENT}"
            conn.options.timeout = 420
                conn.options.open_timeout=180
            case method
              when 'GET'
                retries = 0
                success = false
                while !success and retries < 20
                  begin
                    response = conn.get "#{resource}", data
                    success = true
                    Cnvrg::API.parse_version(response)
                    if response.to_hash[:status].to_i != 200
                      Cnvrg::Logger.log_info("Got back bad status #{response.to_hash[:status]}")
                    end
                    if [503, 502, 429, 401].include?(response.to_hash[:status].to_i)
                      Cnvrg::Logger.log_info("Got back status #{response.to_hash[:status]}, will retry in #{5 * retries} seconds")
                      success = false
                      sleep(5 * retries)
                      retries += 1
                      next
                    end
                  rescue => e
                    Cnvrg::Logger.log_error(e)
                    sleep(5)
                    retries +=1
                  end
                end
                if !success
                  return false
                end
                if response.to_hash[:status] == 404
                  return false
                end
                if parse_request
                    JSON.parse(response.body)
                else
                    response
                end
            when 'POST', 'PUT'
                conn.options.timeout = 4200
                conn.options.open_timeout = 180
                conn.headers['Content-Type'] = "application/json"
                retries = 0
                success = false
                data = data || {}
                while !success and retries < 20
                    begin
                        response = conn.post "#{resource}", data.to_json if method.eql? 'POST'
                        response = conn.put "#{resource}", data.to_json if method.eql? 'PUT'
                        success = true
                        Cnvrg::API.parse_version(response)
                        if response.to_hash[:status].to_i != 200
                          Cnvrg::Logger.log_info("Got back bad status #{response.to_hash[:status]}")
                        end
                        if [503, 502, 429, 401].include?(response.to_hash[:status].to_i)
                          Cnvrg::Logger.log_info("Got back status #{response.to_hash[:status]}, will retry in #{5 * retries} seconds")
                          success = false
                          sleep(5 * retries)
                          retries += 1
                          next
                        end
                    rescue => e
                      Cnvrg::Logger.log_error(e)
                      sleep(5)
                      retries +=1
                    end
                end
                if !success
                    return false
                end
                if response.to_hash[:status] == 404
                  return false
                end
                if parse_request == true
                    JSON.parse(response.body)
                else
                    response
                end
            when 'POST_JSON'
              conn.options.timeout = 4200
              conn.options.open_timeout = 4200
              conn.headers['Content-Type'] = "application/json"
              new_data = JSON.dump(data)

              retries = 0
              success = false

              while !success and retries < 20
                begin
                  response = conn.post "#{resource}", new_data
                  success = true
                rescue => e
                  Cnvrg::Logger.log_error(e)
                  sleep(5)
                  retries +=1
                end
              end
              if !success
                return false
              end
              if response.to_hash[:status] == 404
                return false
              end
              if parse_request == true
                JSON.parse(response.body)
              else
                response
              end
            when 'POST_FILE'
                conn = Faraday.new do |fr|
                    fr.headers['Auth-Token'] = @pass
                    fr.headers['Authorization'] = "CAPI #{@pass}"
                    fr.headers['User-Agent'] = "#{Cnvrg::API::USER_AGENT}"
                    fr.headers["Content-Type"] = "multipart/form-data"
                    if !Helpers.is_verify_ssl
	                      fr.ssl.verify = false
                    end


                    fr.request :multipart
                    fr.request :url_encoded
                    fr.request :retry, max: 2, interval: 0.05,interval_randomness: 0.5, backoff_factor: 2
                    fr.adapter :net_http
                end
                conn.options.timeout = 4200
                conn.options.open_timeout =4200


                # what if windows?
                # data[:file] = Faraday::UploadIO.new(data[:absolute_path], content_type)
                if not File.exists? data[:relative_path]
                  file_base = File.basename(data[:relative_path])

                  begin
                      temp_path = File.expand_path('~')+"/.cnvrg/tmp_files/#{file_base}"
                      FileUtils.touch(temp_path)
                  rescue
                      temp_path ="/tmp/#{file_base}"
                      FileUtils.touch(temp_path)
                  end
                else
                  temp_path = data[:relative_path]
                end


                data[:file] = Faraday::UploadIO.new("#{temp_path}", "application/tar+gzip")

                response = conn.post "#{endpoint_uri}/#{resource}", data
                Cnvrg::API.parse_version(response)
                FileUtils.rm_rf(temp_path)
                if response.to_hash[:status] == 404
                  return false
                end


                if parse_request == true
                    JSON.parse(response.body)
                else
                    response
                end
            when 'DELETE'
                response = conn.delete "#{endpoint_uri}/#{resource}", data
                Cnvrg::API.parse_version(response)
                if response.to_hash[:status] == 404
                  return false
                end
                if parse_request == true
                    JSON.parse(response.body)
                else
                    response
                end
            else
            end
            rescue => e
              Cnvrg::Logger.log_error(e)
               return nil
            rescue SignalException
                return false
            end

        end

        def self.endpoint_uri
            api = get_api()
            return "#{api}/#{Cnvrg::API::ENDPOINT_VERSION}"
        end


        def self.display_error(response)
            "Oops, an error occurred! Reason: #{response['message']}"
        end

      def self.parse_version(resp)
        begin
          version = resp.headers["cnvrg-version"]
          Cnvrg::Helpers.update_version(version)
        rescue => e
          Cnvrg::Logger.log_error(e)
        end
      end

        # Internal: Ensure the response returns a HTTP 200.
        #
        # If the response status isn't a HTTP 200, we need to find out why. This
        # helps identify the issues earlier on and will prevent extra API calls
        # that won't complete.
        #
        # Returns false if the response code isn't a HTTP 200.
    end
end
