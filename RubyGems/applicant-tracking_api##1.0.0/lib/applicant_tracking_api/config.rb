module ApplicantTracking
  class << self
    attr_accessor :domain, :api_key, :api_password, :site, :timeout, :dev_target

    def configure
      yield self

      Resource.user      = api_key
      Resource.password  = api_password
      Resource.timeout   = timeout unless (timeout.blank?)

      self.site ||= (dev_target || "https://#{domain}/remote/")

      Resource.site = site
    end
  end
end
