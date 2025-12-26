require 'acmesmith/challenge_responders/base'
require 'yaml'
require 'rest-client'
require 'resolv'
require 'json'
require 'nsone'

module Acmesmith
  module ChallengeResponders
    class Ns1 < Base

      def support?(type)
        type == 'dns-01'
      end

      def initialize(config)
        @config = config
        @ttl = @config.has_key?(:ttl) ? @config[:ttl] : 3600
        @timeout = 2
        begin
          token = @config.fetch(:token)
        rescue
          warn "ERROR :: Please verify that you add your NS1 account 'Token' config file."
          exit 1
        end
        @ns1 = NSOne::Client.new(token)
      end

      def respond(domain, challenge)
        @zone = find_zone(domain)
        unless @zone
          warn "ERROR :: Domain '#{domain}' is not configured in NS1."
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
          warn "ERROR :: Domain '#{domain}' is not configured in NS1."
          exit 1
        end
        @fqdn = canonicalize(domain, challenge)

        delete_rr(challenge)
        wait_for_sync_by_api(challenge, false)
      end

      private

      def get_rr(challenge)
        begin
          type = challenge.record_type

          res = @ns1.record(@zone, @fqdn, type)

          return res.has_key?("message") && res["message"] == "record not found" ? false : res

        rescue => e
          warn "ERROR :: Failed to get record: #{@fqdn}. error: #{e}"
          exit 3
        end
      end

      def create_rr(challenge)
        begin
          data = {
            "zone" => @zone,
            "domain" => @fqdn,
            "type" => challenge.record_type,
            "answers" => [{"answer" => [challenge.record_content]}],
            "ttl" => @ttl,
          }

          res = @ns1.create_record(@zone, @fqdn, challenge.record_type, data)

          raise "ERROR :: Failed to create record: #{@fqdn} zone: #{@zone}. msg: #{res["message"]}" if res.has_key?("message")

          res

        rescue => e
          warn "ERROR :: error on create -> #{e}"
          exit 3
        end
      end

      def delete_rr(challenge)
        begin
          res = @ns1.delete_record(@zone, @fqdn, challenge.record_type)

          raise "ERROR :: Failed to delete record: #{@fqdn} zone: #{@zone}." if res.has_key?("message")

          res
        rescue => e
          warn "ERROR :: error on delete -> #{e}"
          exit 3
        end
      end

      def wait_for_sync_by_api(challenge, for_create = true)
        puts " * API Check :: Checking if record found using NS1 API --> record: #{@fqdn} expected value: #{challenge.record_content}"

        record = get_rr(challenge)

        if for_create
          while !record
            puts " * Record creation still in process. waiting 3 seconds."
            sleep 3
            record = get_rr(challenge)
          end

          puts " * Confirm new record creation using API!"

          return true
        else
          while record
            puts " * Record deletion still in process. waiting 3 seconds"
            sleep 3
            record = get_rr(challenge)
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

      def canonicalize(domain, challenge)
        "#{challenge.record_name}.#{domain}.".gsub(/\.{2,}/, '.')
      end

      def get_zones()
        @zones ||= @ns1.zones.map {|z| z["zone"]}
      end

      def find_zone(domain)
        get_zones.select {|z| domain[z] }.first
      end

    end # class
  end # module
end # module