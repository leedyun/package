module Assembly
  class Config

    attr_accessor :host, :auth_host, :token, :refresh_token, :client_id, :client_secret, :api_version

    def initialize(options={})
      @host         = "https://api.assembly.education"
      @auth_host    = "https://platform.assembly.education"
      @api_version  = 1
      merge(options)
    end

    def copy_with_overrides(options={})
      copy = self.dup
      copy.merge(options)
      copy
    end

    def merge(options)
      options.each do |key, value|
        send(:"#{key}=", value)
      end
    end
  end
end