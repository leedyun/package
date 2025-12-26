module Octopus
  module ReplicationTracking
    # Extension of Octopus
    module BaseMethods
      def self.extended(base)
        base.extend(ModuleMethods)
      end

      # Define Module methods
      module ModuleMethods
        def replication_position(shard)
          conn = ActiveRecord::Base.connection

          return unless conn.is_a?(Octopus::Proxy)

          using(shard) { conn.replication_position }
        end
      end
    end
  end
end

Octopus.extend(Octopus::ReplicationTracking::BaseMethods)
