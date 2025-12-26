require 'acmesmith/challenge_responders/base'
require 'yaml'
require 'rest-client'
require 'resolv'
require 'json'

module Acmesmith
  module ChallengeResponders
    class Verisign < Base

      @@verisign_rest_url = "https://mdns.verisign.com/mdns-web/api/v1/accounts/"

      def support?(type)
        type == 'dns-01'
      end

      def initialize(config)
        @config = config
        @ttl = @config.has_key?(:ttl) ? @config[:ttl] : 3600
        @timeout = 2
        begin
          @token = @config.fetch(:token)
          @account_id = @config.fetch(:account_id)
        rescue
          warn "ERROR :: Please verify that you add your Verisign account 'Token' and 'ID' to the config file."
          exit 1
        end
      end

      def respond(domain, challenge)
        @zone = find_zone(domain)
        unless @zone
          warn "ERROR :: Domain '#{domain}' is not configured in Verisign."
          exit 1
        end
        @fqdn = canonicalize(domain, challenge)

        create_rr(challenge)
        wait_for_sync_by_api(challenge)
        wait_for_sync_by_dns(challenge)
      end

      def cleanup(domain, challenge)
        @zone = find_zone(domain)
        unless @zone
          warn "ERROR :: Domain '#{domain}' is not configured in Verisign." 
          exit 1
        end
        @fqdn = canonicalize(domain, challenge)

        delete_rr(challenge)
        wait_for_sync_by_api(challenge, false)
      end

      private

      def query!(options = {})
        defaults = { :method => "GET"}
        options = defaults.merge(options)

        method = options[:method].downcase

        begin
          path = "#{@@verisign_rest_url}#{@account_id}#{add_slash(options.fetch(:path))}"
          data = options.fetch(:data).to_json unless method == "get"
        rescue => e
          warn "ERROR :: Please verify that you used all mandatory params: ':path'"
          exit 1
        end

        params = {
          :method => method.to_sym,
          :url => path,
          :timeout => @timeout,
          :open_timeout => @timeout,
          :headers => {
            Authorization: "Token #{@token}",
            content_type: :json,
            accept: :json
          }
        }

        begin
          if method == "get"
            resp = RestClient::Request.execute(params)
          else
            params[:payload] = data
            resp = RestClient::Request.execute(params)
          end

          if method == "get"
            body = JSON.parse(resp.body)

            if body.has_key?("total_count") && body["total_count"] > 0
              body.each do | _key, val |
                if val.kind_of?(Array)
                  return val
                end
              end # each body
            end # if body.has_key?

          end # if method
        rescue RestClient::ExceptionWithResponse => e
          if e.http_code.to_s[/[4][0-9][0-9]/]
            body = JSON.parse(e.response.body)
            err_msg = body ? body['error_messages'] : nil
          end
          warn "Verisign :: Failed to query Verisign and parse response with error: #{e}. err_msg: #{err_msg}"
          exit 2
        rescue => e
          warn "Verisign :: Failed to query Verisign and parse response with error: #{e}."
          exit 2
        end # rescue
      end # def

      def get_rr(challenge)
        begin
          type = challenge.record_type

          params = {:path => "/zones/#{@zone}/rrset/#{@fqdn}/#{type}"}

          query!(params)

        rescue => e
          warn "ERROR :: Failed to get record: #{@fqdn}. error: #{e}"
          exit 3
        end
      end

      def create_rr(challenge)
        begin
          data = {
            "owner" => "#{@fqdn}",
            "type" => challenge.record_type,
            "rdata" => "#{challenge.record_content}",
            "ttl" => @ttl,
            "comments" => "Created by acmesmith-verisign"
          }

          params = {:path => "/zones/#{@zone}/rr", :method => "POST", :data => data}

          query!(params)

        rescue => e
          warn "ERROR :: Failed to create record: #{@fqdn} zone: #{@zone}. error: #{e}"
          exit 3
        end
      end

      def delete_rr(challenge)
        records = get_rr(challenge)
        raise "Failed to delete record. Cannot locate record ID number." if records.empty?

        begin
          record = find_record(records, challenge) 
          rec_id = record[1]

          params = {:path => "/zones/#{@zone}/rr/#{rec_id}", :method => "DELETE", :data => {"comments"=>"Deleted by acmesmith-verisign"}}

          query!(params)
        rescue => e
          warn "ERROR :: Failed to delete record: #{@fqdn} ID: #{rec_id}. zone: #{@zone}. error: #{e}"
          exit 3
        end
      end

      def wait_for_sync_by_api(challenge, for_create = true)
        puts " * API Check :: Checking if record found using Verisign API --> record: #{@fqdn} expected value: #{challenge.record_content}"

        record = find_record(get_rr(challenge), challenge)

        if for_create
          while record == []
            puts " * Record creation still in process. waiting 3 seconds."
            sleep 3
            record = find_record(get_rr(challenge), challenge)
          end

          puts " * Confirm new record creation using API!"

          return true
        else
          while record != []
            puts " * Record deletion still in process. waiting 3 seconds"
            sleep 3
            record = find_record(get_rr(challenge), challenge)
          end

          puts " * Confirm record deletion using API!"

          return true
        end # if for_create
      end # def

      def wait_for_sync_by_dns(challenge)
        value = challenge.record_content
        puts " * DNS CHeck ::  Checking if record found using DNS query --> record: #{@fqdn} expected value: #{challenge.record_content}"

        resolv = Resolv::DNS.new()
        nameservers = resolv.getresources(@zone, Resolv::DNS::Resource::IN::NS).map {|ns| Resolv.getaddresses(ns.name.to_s).first}
        Resolv::DNS.open(:nameserver => nameservers) do | dns |
          dns.timeouts = @timeout

          loop do

            resolv_value = dns.getresources(@fqdn, Resolv::DNS::Resource::IN::TXT).map(&:data).first

            if resolv_value == value
              puts " * Success - Value found and it is as expected. value: #{resolv_value}"
              sleep 1
              break
            else
              puts " * Waiting - Value still does not match the expected result. current value: #{resolv_value}"
              sleep 3
            end

          end # loop
        end # Resolv::DNS
      end # def

      def add_slash(string)
        string[0] != "/" ? string.prepend("/") : string
      end

      def canonicalize(domain, challenge)
        "#{challenge.record_name}.#{domain}.".gsub(/\.{2,}/, '.')
      end

      def get_zones()
        @zones ||= query!({ :path => "/zones" }).map {|zone| zone["zone_name"]}
      end

      def find_zone(zone)
        get_zones.select {|z| zone[z] }.first
      end

      def find_record(array, challenge)
        if array
          array.map! {|r| [r["rdata"].gsub(/"/, ""), r["resource_record_id"]]}
          return array.select {|r| r.include?("#{challenge.record_content}")}.flatten
        end
        
        return []
      end

    end # class
  end # module
end # module