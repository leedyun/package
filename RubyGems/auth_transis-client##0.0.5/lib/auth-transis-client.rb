require "auth-transis-client/version"
require 'omniauth'
require 'omniauth-oauth2'
require "omni_auth"
require 'faraday_middleware'

module Auth
  module Transis
    class Client
      def initialize(opts={})
        fill_in_access_token!(opts)
        if opts[:site] && opts[:token]
          @connection = Faraday.new opts[:site] do |conn|
            conn.request :oauth2, opts[:token]
            conn.request :json

            conn.response :json, :content_type => /\bjson$/

            conn.adapter Faraday.default_adapter
          end
        else
          raise <<-ERROR
            Either provide :token or provide :site, :username, :password, :client_id, and :client_secret
          ERROR
        end
      end

      def fill_in_access_token!(opts)
        return if opts[:token]
        return unless opts[:site] && opts[:username] && opts[:client_id] && opts[:client_secret]
        connection = Faraday.new opts[:site] do |conn|
          conn.request :json
          conn.response :json, :content_type => /\bjson$/
          conn.use :instrumentation
          conn.adapter Faraday.default_adapter
        end
        response = connection.post('/oauth/token',
                 :grant_type    => 'password',
                 :client_id     => opts[:client_id],
                 :client_secret => opts[:client_secret],
                 :username      => opts[:username],
                 :password      => opts[:password])
        raise 'Failed to get an access token' unless response.success? && response.body['access_token']
        opts[:token] = response.body['access_token']
      end

      def get_credentials
        @connection.get('/api/v1/me.json').body
      end

      def get_organizations(user_id=nil)
        options = {}
        options[:user_id]=user_id if user_id
        @connection.get("/api/#{API_VERSION}/organizations.json", options).body
      end

      def get_members_of_organization(organization_id)
        @connection.get("/api/#{API_VERSION}/organizations/#{organization_id}/members.json").body
      end

      ##
      # Creates a user in an organization.  If the user already exists in AuthTransis they will
      # simply be added to the org (assuming the resource owner has rights), if they don't exist
      # they will be created and added to the organizations.
      #
      # Returns a list of the organizations that they were sucessfully added to.
      def create_user_in_organization(email, organization_id)
        org_ids = organization_id.respond_to?(:each) ? organization_id : [organization_id]
        successfuls = []
        org_ids.each do |org_id|
          response = @connection.post("/api/#{API_VERSION}/organizations/#{organization_id}/members.json", {:email_address => email})
          response.success? && successfuls << response.body
        end
        successfuls
      end

      def create_user(email)
        response = @connection.post("/api/#{API_VERSION}/members.json", {:email_address => email})
        response.success? && response.body
      end

      def create_organization(org_name)
        response = @connection.post("/api/#{API_VERSION}/organizations", {:name => org_name})
        response.success? && response.body
      end
    end
  end
end
