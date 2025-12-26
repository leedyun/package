module AccessPolicyRails
  require 'delegate'

  class PolicyWrapper <  SimpleDelegator
    def allow?(permission)
      permission = permission.to_s.end_with?('?') ? permission : "#{permission}?"
      self.send(permission)
    end
  end

end