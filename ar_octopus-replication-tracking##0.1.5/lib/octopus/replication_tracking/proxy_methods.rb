module Octopus
  module ReplicationTracking
    # Extension of Octopus::Proxy
    module ProxyMethods
      def self.extended(base)
        base.send(:include, InstanceMethods)
      end

      # Define Instance methods
      module InstanceMethods
        def master_shard?
          current_shard == Octopus.master_shard
        end

        def replication_position
          master_shard? ? master_replication_status : slave_replication_status
        end

        private

        def master_replication_status
          status_result = execute('SHOW MASTER STATUS;').first
          {
            file_name: status_result.try(:[], 0),
            position: status_result.try(:[], 1)
          }
        end

        def slave_replication_status
          status_result = execute('SHOW SLAVE STATUS;').first
          {
            file_name: status_result.try(:[], 5),
            position: status_result.try(:[], 6)
          }
        end
      end
    end
  end
end

Octopus::Proxy.extend(Octopus::ReplicationTracking::ProxyMethods)
