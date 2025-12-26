require 'json'
require 'oauth2'

module Android
  class Publisher
    class Secrets
      # @example
      #   {
      #     "web": {
      #       "client_id": "asdfjasdljfasdkjf",
      #       "client_secret": "1912308409123890",
      #       "redirect_uris": ["https://www.example.com/oauth2callback"],
      #       "auth_uri": "https://accounts.android.com/o/oauth2/auth",
      #       "token_uri": "https://accounts.android.com/o/oauth2/token"
      #     }
      #   }
      #
      # @example
      #   {
      #     "installed": {
      #       "client_id": "837647042410-75ifg...usercontent.com",
      #       "client_secret":"asdlkfjaskd",
      #       "redirect_uris": ["http://localhost", "urn:ietf:oauth:2.0:oob"],
      #       "auth_uri": "https://accounts.android.com/o/oauth2/auth",
      #       "token_uri": "https://accounts.android.com/o/oauth2/token"
      #     }
      #   }
      def self.load(filename=nil)
        while filename == nil
          search_path ||= File.expand_path('.')
          if File.exist?(File.join(search_path, 'client_secrets.json'))
            filename = File.join(search_path, 'client_secrets.json')
          else
            raise ArgumentError,
                  'No client_secrets.json filename supplied ' +
                    'and/or could not be found in search path.'
          end
        end
        data = File.open(filename, 'r') { |file| JSON.parse(file.read) }
        return self.new(data)
      end

      ##
      # Intialize OAuth client settings.
      #
      # @param [Hash] options
      #   Parsed client secrets files
      def initialize(options={})
        @flow = options[:flow] || options.keys.first.to_s || 'web'
        fdata = options[@flow]

        # Client auth config
        @client_id = fdata[:client_id] || fdata["client_id"]
        @client_secret = fdata[:client_secret] || fdata["client_secret"]

        # Redirects info
        @redirect_uris      = fdata[:redirect_uris]       || fdata["redirect_uris"]     || [fdata[:redirect_uri]]
        @javascript_origins = fdata[:javascript_origins]  || fdata["javascript_origins"]|| [fdata[:javascript_origin]]

        # Endpoints info
        @authorization_uri    = URI.parse(fdata[:auth_uri]  || fdata["auth_uri"]  || fdata[:authorization_uri])
        @token_credential_uri = URI.parse(fdata[:token_uri] || fdata["token_uri"] || fdata[:token_credential_uri])

        # Associated token info
        @access_token   = fdata[:access_token]  || fdata["access_token"]
        @refresh_token  = fdata[:refresh_token] || fdata["refresh_token"]
        @id_token       = fdata[:id_token]      || fdata["id_token"]
        @expires_in     = fdata[:expires_in]    || fdata["expires_in"]
        @expires_at     = fdata[:expires_at]    || fdata["expires_at"]
        @issued_at      = fdata[:issued_at]     || fdata["issued_at"]
      end

      attr_reader(
        :flow, :client_id, :client_secret, :redirect_uris, :javascript_origins,
        :authorization_uri, :token_credential_uri, :access_token,
        :refresh_token, :id_token, :expires_in, :expires_at, :issued_at
      )

      def to_authorized_connection
        # OAuth2::Client.new(
        #   "49761657086.apps.googleusercontent.com", "Cp43nWEtueuPVEKPDJhmr4Mb",
        #   {:site => "https://accounts.android.com/", :authorize_url=>"/o/oauth2/auth", :token_url=>"/o/oauth2/token"}
        # )
        params = {
          :site           =>  URI.join(authorization_uri, '/'),
          :authorize_url  =>  authorization_uri.path,
          :token_url      =>  token_credential_uri.path
        }
        client = OAuth2::Client.new(client_id, client_secret, params)
        token  = OAuth2::AccessToken.new(client, access_token, { :refresh_token => refresh_token })
        token.refresh!
      end
    end
  end
end