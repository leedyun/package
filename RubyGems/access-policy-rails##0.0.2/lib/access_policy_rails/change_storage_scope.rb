module AccessPolicyRails

  module ChangedScopeStorage
    def self.call
      AccessPolicy.module_exec do
        def _scope_storage
          AccessPolicyRails::RequestLocalStorage
        end
      end
    end
  end

end

AccessPolicyRails::ChangedScopeStorage.call