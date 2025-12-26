module AccessPolicyRails
  require 'request_store'

  class RequestLocalStorage < ScopedStorage::ThreadLocalStorage

    def self.for(scope_name="default")
      RequestStore.store["_#{name}_#{scope_name}"] ||= new
    end

  end
end

