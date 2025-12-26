module Fog
  module Ovirt
    class Compute
      class Template < Fog::Model
        identity :id

        attr_accessor :raw

        attribute :name
        attribute :comment
        attribute :description
        attribute :profile
        attribute :display
        attribute :storage, :aliases => "disk_size"
        attribute :creation_time
        attribute :os
        attribute :status
        attribute :cores, :aliases => "cpus"
        attribute :memory
        attribute :cluster
        attribute :interfaces
        attribute :volumes
        attribute :version

        def interfaces
          attributes[:interfaces] ||= if id.nil?
                                        []
                                      else
                                        Fog::Ovirt::Compute::Interfaces.new(
                                          :service => service,
                                          :vm => self
                                        )
                                      end
        end

        def volumes
          attributes[:volumes] ||= if id.nil?
                                     []
                                   else
                                     Fog::Ovirt::Compute::Volumes.new(
                                       :service => service,
                                       :vm => self
                                     )
                                   end
        end

        def ready?
          status !~ /down/i
        end

        def destroy(_options = {})
          service.client.destroy_template(id)
        end

        def save
          raise ::Fog::Ovirt::Errors::OvirtError, "Providing an existing object may create a duplicate object" if persisted?
          service.client.create_template(attributes)
        end

        def to_s
          name
        end
      end
    end
  end
end
